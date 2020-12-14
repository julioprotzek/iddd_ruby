class Telephone
  include Concerns::Assertion

  attr_reader :number

  def initialize(number)
    assert_argument_presence(number, 'Telephone number is required.')
    assert_argument_length(number, 5, 20, 'Telephone number may not be more than 20 characters.')
    assert_argument_true(number.match?(/((\(\d{3}\) ?)|(\d{3}-))\d{3}-\d{4}/), 'Telephone number or its format is invalid.')

    @number = number
  end
end