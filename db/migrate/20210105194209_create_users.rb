class CreateUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :users do |t|
      t.string :tenant_id_id, index: true
      t.boolean :enablement_enabled
      t.date :enablement_start_at
      t.date :enablement_end_at
      t.string :password_hash
      t.string :username
      t.timestamps
    end
  end
end
