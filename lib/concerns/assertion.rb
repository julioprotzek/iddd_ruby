module Concerns::Assertion
  def assert_argument_presence(argument, message)
    raise ArgumentError, message unless argument.present?
  end

  def assert_argument_length(argument, min, max, message)
    raise ArgumentError, message unless argument.length.between?(min, max)
  end

  def assert_argument_true(is_true, message)
    raise ArgumentError, message unless is_true
  end
end