class CreateStoredEvents < ActiveRecord::Migration[6.1]
  def change
    create_table :stored_events do |t|
      t.integer :event_id
      t.text :body
      t.string :type_name
      t.datetime :occurred_at

      t.timestamps
    end
  end
end
