class ChangePostalAddressCommand
  attr_accessor :tenant_id, :username, :street_address, :city, :state_province, :postal_code, :country_code

  def initialize(tenant_id:, username:, street_address:, city:, state_province:, postal_code:, country_code:)
    @tenant_id = tenant_id
    @username = username
    @street_address = street_address
    @city = city
    @state_province = state_province
    @postal_code = postal_code
    @country_code = country_code
  end
end