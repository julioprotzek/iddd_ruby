class ChangeContactInfoCommand
  attr_accessor :tenant_id, :username, :email_address, :primary_phone, :secondary_phone, :street_address, :city, :state_province, :postal_code, :country_code

  def initialize(tenant_id:, username:, email_address:, primary_phone:, secondary_phone:, street_address:, city:, state_province:, postal_code:, country_code:)
    @tenant_id = tenant_id
    @username = username
    @email_address = email_address
    @primary_phone = primary_phone
    @secondary_phone = secondary_phone
    @street_address = street_address
    @city = city
    @state_province = state_province
    @postal_code = postal_code
    @country_code = country_code
  end
end