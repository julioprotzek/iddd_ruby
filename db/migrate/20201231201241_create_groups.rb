class CreateGroups < ActiveRecord::Migration[6.1]
  def change
    create_table :groups do |t|
      t.string :key, index: { unique: true }
      t.string :tenant_id_id, index: true
      t.string :name
      t.text :description

      t.timestamps
    end
  end
end
