class CreatePersons < ActiveRecord::Migration[6.1]
  def change
    create_table :persons do |t|
      t.string :tenant_id_id, index: true
      t.string :contact_information_email_address
      t.string :contact_information_postal_address_city
      t.string :contact_information_postal_address_country_code
      t.string :contact_information_postal_address_postal_code
      t.string :contact_information_postal_address_state_province
      t.string :contact_information_postal_address_street_address
      t.string :contact_information_primary_phone_number
      t.string :contact_information_secondary_phone_number
      t.string :name_first_name
      t.string :name_last_name
      t.references :user

      t.timestamps
    end
  end
end
