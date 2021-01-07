class CreateRegistrationInvitations < ActiveRecord::Migration[6.1]
  def change
    create_table :registration_invitations do |t|
      t.string :tenant_id_id, index: true
      t.text :description
      t.string :invitation_id
      t.date :starts_at
      t.date :ends_at

      t.timestamps

      t.references :tenant
    end
  end
end
