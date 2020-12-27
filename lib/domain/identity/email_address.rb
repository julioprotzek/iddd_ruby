class EmailAddress
  include Assertion
  attr_reader :address
  EMAIL_FORMAT = /\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*/

  def initialize(address)
    assert_presence(address, 'The email address is required.')
    assert_length(address, 1, 100, 'The email address must be 100 characters or less.')
    assert(address.match?(EMAIL_FORMAT), 'Email address format is invalid.')

    @address = address
  end

  def ==(other)
    self.class == other.class && address == other.address
  end
end