module Concerns::Assertion
  def assert_presence(argument, message)
    raise ArgumentError, message unless argument.present?
  end

  def assert_length(argument, min, max, message)
    raise ArgumentError, message unless argument.length.between?(min, max)
  end

  def assert(is_true, message)
    raise ArgumentError, message unless is_true
  end
end