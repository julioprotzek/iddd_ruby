class CreatePublisherNotificationTrackers < ActiveRecord::Migration[6.1]
  def change
    create_table :published_notification_trackers do |t|
      t.integer :most_recent_published_notification_id
      t.string :type_name
    end
  end
end
