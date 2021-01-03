class ChangeTypeToMemberTypeOnGroupMembers < ActiveRecord::Migration[6.1]
  def change
    rename_column :group_members, :type, :member_type
  end
end
