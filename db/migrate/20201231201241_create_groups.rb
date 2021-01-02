class CreateGroups < ActiveRecord::Migration[6.1]
  def change
    create_table :groups do |t|
      t.string :tenant_id_id, index: true
      t.string :name, index: true
      t.text :description

      t.timestamps
    end
  end
end
