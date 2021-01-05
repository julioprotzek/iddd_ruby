class ActiveRecord::UserRepository
  class UserModel < ActiveRecord::Base
    has_one :person, class_name: 'PersonModel', foreign_key: 'user_id', dependent: :delete
    self.table_name = 'users'
    validates :username, uniqueness: { scope: :tenant_id_id }
  end

  class PersonModel < ActiveRecord::Base
    belongs_to :user, class_name: 'UserModel', foreign_key: 'user_id'
    self.table_name = 'persons'
  end

  def add(user)
    record = find_record_for(user)

    if record.present?
      record.update(hash_from_aggregate(user))
    else
      record = UserModel.create!(hash_from_aggregate(user))
    end

    as_aggregate(record)
  rescue
    raise StandardError, 'User is not unique.'
  end

  def find_by(tenant_id:, username:)
    record = UserModel.find_by(tenant_id_id: tenant_id.id, username: username)

    if record.present?
      as_aggregate(record)
    end
  end

  def all_similar_named_users(tenant_id:, first_name_prefix:, last_name_prefix:)
    PersonModel
      .where(tenant_id_id: tenant_id.id)
      .where("name_first_name LIKE :prefix", prefix: "#{first_name_prefix}%")
      .where("name_last_name LIKE :prefix", prefix: "#{last_name_prefix}%")
      .to_a
      .map{ |record| as_aggregate(record.user) }
  end

  def remove(user)
    find_record_for(user).delete
    nil
  end

  def clean
    UserModel.delete_all
  end

  private

  def as_aggregate(record)
    User.new(
      tenant_id: TenantId.new(record.tenant_id_id),
      username: record.username,
      password: record.password,
      enablement: Enablement.new(
        enabled: record.enablement_enabled,
        start_at: record.enablement_start_at,
        end_at: record.enablement_end_at
      ),
      person: Person.new(
        tenant_id: TenantId.new(record.tenant_id_id),
        name: FullName.new(
          first_name: record.person.name_first_name,
          last_name: record.person.name_last_name
        ),
        contact_information: ContactInformation.new(
          email_address: EmailAddress.new(record.person.contact_information_email_address),
          postal_address: PostalAddress.new(
            street_address: record.person.contact_information_postal_address_street_address,
            city: record.person.contact_information_postal_address_city,
            state_province: record.person.contact_information_postal_address_state_province,
            postal_code: record.person.contact_information_postal_address_postal_code,
            country_code: record.person.contact_information_postal_address_country_code
          ),
          primary_phone: PhoneNumber.new(record.person.contact_information_primary_phone_number),
          secondary_phone: PhoneNumber.new(record.person.contact_information_secondary_phone_number)
        )
      )
    )
  end

  def hash_from_aggregate(user)
    user_hash = user.as_json.deep_symbolize_keys
    user_hash[:tenant_id_id] = user_hash.delete(:tenant_id)[:id]
    user_hash[:enablement_enabled] = user_hash[:enablement][:enabled]
    user_hash[:enablement_start_at] = user_hash[:enablement][:start_at]
    user_hash[:enablement_end_at] = user_hash[:enablement][:end_at]
    user_hash.delete(:enablement)

    user_hash[:person][:tenant_id_id] = user_hash[:person].delete(:tenant_id)[:id]
    user_hash[:person][:name_first_name] = user_hash[:person][:name][:first_name]
    user_hash[:person][:name_last_name] = user_hash[:person][:name][:last_name]
    user_hash[:person].delete(:name)
    user_hash[:person][:contact_information_email_address] = user_hash[:person][:contact_information][:email_address][:address]
    user_hash[:person][:contact_information_postal_address_city] = user_hash[:person][:contact_information][:postal_address][:city]
    user_hash[:person][:contact_information_postal_address_country_code] = user_hash[:person][:contact_information][:postal_address][:country_code]
    user_hash[:person][:contact_information_postal_address_postal_code] = user_hash[:person][:contact_information][:postal_address][:postal_code]
    user_hash[:person][:contact_information_postal_address_state_province] = user_hash[:person][:contact_information][:postal_address][:state_province]
    user_hash[:person][:contact_information_postal_address_street_address] = user_hash[:person][:contact_information][:postal_address][:street_address]
    user_hash[:person][:contact_information_primary_phone_number] = user_hash[:person][:contact_information][:primary_phone][:number]
    user_hash[:person][:contact_information_secondary_phone_number] = user_hash[:person][:contact_information][:secondary_phone][:number]
    user_hash[:person].delete(:contact_information)

    user_hash[:person] = PersonModel.new(user_hash[:person])

    user_hash
  end

  def find_record_for(user)
    UserModel.find_by(tenant_id_id: user.tenant_id.id, username: user.username)
  end
end