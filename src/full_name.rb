require 'active_support/all'

class FullName
  attr_reader :first_name, :last_name

  def initialize(first_name, last_name)
    self.first_name = first_name
    self.last_name = last_name
  end

  def first_name=(first_name)
    assert_argument_presence(first_name, 'First name is required.')
    assert_argument_length(first_name, 1, 50, 'First name must have 50 characters or less.')
    assert_argument_true(first_name.match?(/[A-Z][a-z]*/), 'First name must be at least one character in length, starting with a capital letter.')

    @first_name = first_name
  end

  def last_name=(last_name)
    assert_argument_presence(last_name, 'Last name is required.')
    assert_argument_length(last_name, 1, 50, 'Last name must have 50 characters or less.')
    assert_argument_true(last_name.match?(/^[a-zA-Z][ a-zA-Z'-]*[a-zA-Z']?/), 'Last name must be at least one character in length.')

    @last_name = last_name
  end

  def with_changed_first_name(first_name)
    self.class.new(first_name, @last_name)
  end

  def with_changed_last_name(last_name)
    self.class.new(@first_name, last_name)
  end

  def as_formatted_name
    @first_name + ' ' + @last_name
  end

  private

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