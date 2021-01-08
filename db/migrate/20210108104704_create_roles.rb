class CreateRoles < ActiveRecord::Migration[6.1]
  def change
    create_table :roles do |t|
      t.string :tenant_id_id, index: true
      t.string :name
      t.text :description
      t.boolean :supports_nesting
      t.timestamps
      t.references :group
    end
  end
end
