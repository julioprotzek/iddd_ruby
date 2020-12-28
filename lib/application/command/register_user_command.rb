class RegisterUserCommand
  attr_accessor :tenant_id,
                :invitation_identifier,
                :username,
                :password,
                :first_name,
                :last_name,
                :enabled,
                :start_at,
                :end_at,
                :email_address,
                :primary_phone,
                :secondary_phone,
                :address_street_address,
                :address_city,
                :address_state_province,
                :address_postal_code,
                :address_country_code

  def initialize(tenant_id:, invitation_identifier:, username:, password:, first_name:, last_name:, enabled:, start_at:, end_at:, email_address:, primary_phone:, secondary_phone: nil, address_street_address:, address_city:, address_state_province:, address_postal_code:, address_country_code:)
    @tenant_id = tenant_id
    @invitation_identifier = invitation_identifier
    @username = username
    @password = password
    @first_name = first_name
    @last_name = last_name
    @enabled = enabled
    @start_at = start_at
    @end_at = end_at
    @email_address = email_address
    @primary_phone = primary_phone
    @secondary_phone = secondary_phone
    @address_street_address = address_street_address
    @address_city = address_city
    @address_state_province = address_state_province
    @address_postal_code = address_postal_code
    @address_country_code = address_country_code
  end
end