class ProvisionTenantCommand
  attr_accessor :tenant_name,
                :tenant_description,
                :administrator_first_name,
                :administrator_last_name,
                :email_address,
                :primary_phone,
                :secondary_phone,
                :address_street_address,
                :address_city,
                :address_state_province,
                :address_postal_code,
                :address_country_code

  def initialize(tenant_name:, tenant_description:, administrator_first_name:, administrator_last_name:, email_address:, primary_phone:, secondary_phone: nil, address_street_address:, address_city:, address_state_province:, address_postal_code:, address_country_code:)
    @tenant_name = tenant_name
    @tenant_description = tenant_description
    @administrator_first_name = administrator_first_name
    @administrator_last_name = administrator_last_name
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