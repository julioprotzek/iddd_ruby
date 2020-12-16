module Concerns::Assertion
  def assert_presence(argument, message)
    raise ArgumentError, message unless argument.present?
  end

  def assert_presence_kind_of(argument, klass, message)
    raise ArgumentError, "Expected #{klass.name} but received #{argument.class.name}" unless argument.kind_of? klass
    assert_presence(argument, message)
  end

  def assert_length(argument, min, max, message)
    raise ArgumentError, message unless argument.length.between?(min, max)
  end

  def assert_equal(argument1, argument2, message)
    raise ArgumentError, message unless argument1 == argument2
  end

  def assert(is_true, message)
    raise ArgumentError, message unless is_true
  end
end