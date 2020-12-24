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

    a_group.group_members.each do |member|
      if member.is_a?(Group)
        is_member = a_member_group == member
        break if is_member

        is_member = member_group?(member, a_member_group)
        break if is_member
      end
    end

    is_member
  end

  private

  attr_reader :group_repository, :user_repository
end