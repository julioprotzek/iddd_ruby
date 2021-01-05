class GroupMemberService
  def initialize(group_repository:, user_repository:)
    @group_repository = group_repository
    @user_repository = user_repository
  end

  def confirm_user(group, user)
    user = user_repository.find_by(tenant_id: group.tenant_id, username: user.username)
    user.present? && user.enabled?
  end

  def member_group?(group, member_group)
    is_member = false

    group.members.each do |member|
      if member.group?
        is_member = member_group.as_member == member
        break if is_member

        group = group_repository.group_named(member.tenant_id, member.name)
        is_member = group.present? && member_group?(group, member_group)
        break if is_member
      end
    end

    is_member
  end

  def in_nested_group?(group, user)
    in_nested_group = false

    group.members.each do |member|
      if member.group?
        group = group_repository.group_named(member.tenant_id, member.name)

        in_nested_group = group.present? && group.member?(user, self)
        break if in_nested_group
      end
    end

    in_nested_group
  end

  private

  attr_reader :group_repository, :user_repository
end