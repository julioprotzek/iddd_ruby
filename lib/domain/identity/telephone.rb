class Telephone
  include Assertion

  attr_reader :number

  def initialize(a_number)
    assert_presence(a_number, 'Telephone number is required.')
    assert_length(a_number, 5, 20, 'Telephone number may not be more than 20 characters.')
    assert(a_number.match?(/((\(\d{3}\) ?)|(\d{3}-))\d{3}-\d{4}/), 'Telephone number or its format is invalid.')

    @number = a_number
  end

  def ==(other)
    self.class == other.class && self.number == other.number
  end
end