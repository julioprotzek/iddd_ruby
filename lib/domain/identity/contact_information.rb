class ContactInformation
  include Assertion

  attr_reader :email_address, :postal_address, :primary_phone, :secondary_phone

  def initialize(email_address:, postal_address:, primary_phone:, secondary_phone:)
    self.email_address = email_address
    self.postal_address = postal_address
    self.primary_phone = primary_phone
    self.secondary_phone = secondary_phone
  end

  def change_email_address(email_address)
    self.class.new(
      email_address: email_address,
      postal_address: postal_address,
      primary_phone: primary_phone,
      secondary_phone: secondary_phone
    )
  end

  def change_postal_address(postal_address)
    self.class.new(
      email_address: email_address,
      postal_address: postal_address,
      primary_phone: primary_phone,
      secondary_phone: secondary_phone
    )
  end

  def change_primary_phone(primary_phone)
    self.class.new(
      email_address: email_address,
      postal_address: postal_address,
      primary_phone: primary_phone,
      secondary_phone: secondary_phone
    )
  end

  def change_secondary_phone(secondary_phone)
    self.class.new(
      email_address: email_address,
      postal_address: postal_address,
      primary_phone: primary_phone,
      secondary_phone: secondary_phone
    )
  end

  def ==(other)
    self.class == other.class &&
    self.email_address == other.email_address &&
    self.postal_address == other.postal_address &&
    self.primary_phone == other.primary_phone &&
    self.secondary_phone == other.secondary_phone
  end

  private

  def email_address=(email_address)
    assert_presence(email_address, 'The email address is required.')

    @email_address = email_address
  end

  def postal_address=(postal_address)
    assert_presence(postal_address, 'The postal address is required.')

    @postal_address = postal_address
  end

  def primary_phone=(primary_phone)
    assert_presence(primary_phone, 'The primary telephone is required.')

    @primary_phone = primary_phone
  end

  def secondary_phone=(secondary_phone)
    @secondary_phone = secondary_phone
  end
end