require 'minitest/autorun'

require './full_name'

class FullNameTest < Minitest::Test
  FIRST_NAME = 'Zoe'
  LAST_NAME = 'Doe'
  MARRIED_LAST_NAME = 'Jones-Doe'
  WRONG_FIRST_NAME = 'Zeo'

  def test_changed_first_name
    name = FullName.new(WRONG_FIRST_NAME, LAST_NAME)
    name = name.with_changed_first_name(FIRST_NAME)

    assert_equal FIRST_NAME + ' ' + LAST_NAME, name.as_formatted_name
  end

  def test_changed_last_name
    name = FullName.new(FIRST_NAME, LAST_NAME)
    name = name.with_changed_last_name(MARRIED_LAST_NAME)

    assert_equal FIRST_NAME + ' ' + MARRIED_LAST_NAME, name.as_formatted_name
  end

  def test_formatted_name
    name = FullName.new(FIRST_NAME, LAST_NAME)
    assert_equal FIRST_NAME + ' ' + LAST_NAME, name.as_formatted_name
  end

  def test_first_name_is_required
    assert_raises('First name is required') do
      FullName.new(nil, LAST_NAME)
    end
  end
end