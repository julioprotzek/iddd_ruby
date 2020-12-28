class PhoneNumber
  include Assertion

  attr_reader :number

  def initialize(number)
    assert_presence(number, 'PhoneNumber number is required.')
    assert_length(number, 5, 20, 'PhoneNumber number may not be more than 20 characters.')
    assert(number.match?(/((\(\d{3}\) ?)|(\d{3}-))\d{3}-\d{4}/), 'PhoneNumber number or its format is invalid.')

    @number = number
  end

  def ==(other)
    self.class == other.class && self.number == other.number
  end
end
