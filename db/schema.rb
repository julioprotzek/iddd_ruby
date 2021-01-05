# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2021_01_05_194531) do

  create_table "group_members", force: :cascade do |t|
    t.string "tenant_id_id"
    t.string "name"
    t.integer "group_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "member_type"
    t.index ["group_id"], name: "index_group_members_on_group_id"
    t.index ["tenant_id_id"], name: "index_group_members_on_tenant_id_id"
  end

  create_table "groups", force: :cascade do |t|
    t.string "tenant_id_id"
    t.string "name"
    t.text "description"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["name"], name: "index_groups_on_name"
    t.index ["tenant_id_id"], name: "index_groups_on_tenant_id_id"
  end

  create_table "persons", force: :cascade do |t|
    t.string "tenant_id_id"
    t.string "contact_information_email_address"
    t.string "contact_information_postal_address_city"
    t.string "contact_information_postal_address_country_code"
    t.string "contact_information_postal_address_postal_code"
    t.string "contact_information_postal_address_state_province"
    t.string "contact_information_postal_address_street_address"
    t.string "contact_information_primary_phone_number"
    t.string "contact_information_secondary_phone_number"
    t.string "name_first_name"
    t.string "name_last_name"
    t.integer "user_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["tenant_id_id"], name: "index_persons_on_tenant_id_id"
    t.index ["user_id"], name: "index_persons_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "tenant_id_id"
    t.boolean "enablement_enabled"
    t.date "enablement_start_at"
    t.date "enablement_end_at"
    t.string "password"
    t.string "username"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["tenant_id_id"], name: "index_users_on_tenant_id_id"
  end

end
