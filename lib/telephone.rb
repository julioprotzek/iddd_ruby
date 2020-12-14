class Telephone
  include Concerns::Assertion

  attr_reader :number

  def initialize(number)
    assert_argument_presence(number, 'Telephone number is required.')
    @number = number
  end
end