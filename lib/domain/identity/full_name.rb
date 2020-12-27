class FullName
  include Assertion

  attr_reader :first_name, :last_name

  def initialize(first_name, last_name)
    self.first_name = first_name
    self.last_name = last_name
  end

  def first_name=(first_name)
    assert_presence(first_name, 'First name is required.')
    assert_length(first_name, 1, 50, 'First name must have 50 characters or less.')
    assert(first_name.match?(/[A-Z][a-z]*/), 'First name must be at least one character in length, starting with a capital letter.')

    @first_name = first_name
  end

  def last_name=(last_name)
    assert_presence(last_name, 'Last name is required.')
    assert_length(last_name, 1, 50, 'Last name must have 50 characters or less.')
    assert(last_name.match?(/^[a-zA-Z][ a-zA-Z'-]*[a-zA-Z']?/), 'Last name must be at least one character in length.')

    @last_name = last_name
  end

  def with_changed_first_name(first_name)
    self.class.new(first_name, last_name)
  end

  def with_changed_last_name(last_name)
    self.class.new(first_name, last_name)
  end

  def as_formatted_name
    first_name + ' ' + last_name
  end

  def ==(other)
    self.class == other.class && self.first_name == other.first_name && self.last_name == other.last_name
  end
end