class CreateGroupMembers < ActiveRecord::Migration[6.1]
  def change
    create_table :group_members do |t|
      t.string :tenant_id_id, index: true
      t.string :name
      t.string :type
      t.references :group

      t.timestamps
    end
  end
end
