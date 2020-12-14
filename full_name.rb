require 'active_support/all'

class FullName
  def initialize(first_name, last_name)
    assert_argument_not_empty(first_name, "First name is required.")
    @first_name = first_name
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

  def assert_argument_not_empty(argument, message)
    raise ArgumentError, message unless argument.present?
  end
end