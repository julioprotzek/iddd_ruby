class FullName
  include Concerns::Assertion

  attr_reader :first_name, :last_name

  def initialize(a_first_name, a_last_name)
    self.first_name = a_first_name
    self.last_name = a_last_name
  end

  def first_name=(a_first_name)
    assert_presence(a_first_name, 'First name is required.')
    assert_length(a_first_name, 1, 50, 'First name must have 50 characters or less.')
    assert(a_first_name.match?(/[A-Z][a-z]*/), 'First name must be at least one character in length, starting with a capital letter.')

    @first_name = a_first_name
  end

  def last_name=(a_last_name)
    assert_presence(a_last_name, 'Last name is required.')
    assert_length(a_last_name, 1, 50, 'Last name must have 50 characters or less.')
    assert(a_last_name.match?(/^[a-zA-Z][ a-zA-Z'-]*[a-zA-Z']?/), 'Last name must be at least one character in length.')

    @last_name = a_last_name
  end

  def with_changed_first_name(a_first_name)
    self.class.new(a_first_name, last_name)
  end

  def with_changed_last_name(a_last_name)
    self.class.new(first_name, a_last_name)
  end

  def as_formatted_name
    first_name + ' ' + last_name
  end
end