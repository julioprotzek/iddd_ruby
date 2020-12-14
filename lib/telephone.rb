class Telephone
  attr_reader :number

  def initialize(number)
    assert_argument_presence(number, 'Telephone number is required.')
    @number = number
  end

  private

  def assert_argument_presence(argument, message)
    raise ArgumentError, message unless argument.present?
  end
end