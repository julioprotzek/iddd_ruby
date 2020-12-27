class GroupMemberService
  def initialize(group_repository:, user_repository:)
    @group_repository = group_repository
    @user_repository = user_repository
  end

  def confirm_user(a_group, an_user)
    user = user_repository.find_by(tenant_id: a_group.tenant_id, username: an_user.username)
    user.present? && user.enabled?
  end

  def member_group?(a_group, a_member_group)
    is_member = false

    a_group.members.each do |member|
      if member.is_a?(Group)
        is_member = a_member_group == member
        break if is_member

        group = group_repository.group_named(member.tenant_id, member.name)
        is_member = group.present? && member_group?(group, a_member_group)
        break if is_member
      end
    end

    is_member
  end

  def in_nested_group?(a_group, an_user)
    in_nested_group = false

    a_group.members.each do |member|
      if member.is_a?(Group)
        group = group_repository.group_named(member.tenant_id, member.name)

        in_nested_group = group.present? && group.member?(an_user, self)
        break if in_nested_group
      end
    end

    in_nested_group
  end

  private

  attr_reader :group_repository, :user_repository
end