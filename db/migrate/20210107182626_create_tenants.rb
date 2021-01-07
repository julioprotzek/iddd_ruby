class CreateTenants < ActiveRecord::Migration[6.1]
  def change
    create_table :tenants do |t|
      t.string :tenant_id_id, index: true
      t.boolean :active
      t.text :description
      t.string :name

      t.timestamps
    end
  end
end
