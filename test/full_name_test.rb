require './test/test_helper'

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
    error = assert_raises(ArgumentError) do
      FullName.new(nil, LAST_NAME)
    end
    assert_equal error.message, 'First name is required.'
    
    error = assert_raises(ArgumentError) do
      FullName.new('', LAST_NAME)
    end
    assert_equal error.message, 'First name is required.'
  end
  
  def test_first_name_limit
    error = assert_raises(ArgumentError) do
      FullName.new('Loooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooonnnng', LAST_NAME)
    end
    assert_equal error.message, 'First name must have 50 characters or less.'
  end

  def test_first_name_characters
    error = assert_raises(ArgumentError) do
      FullName.new('1', LAST_NAME)
    end
    assert_equal error.message, 'First name must be at least one character in length, starting with a capital letter.'
  end

  def test_last_name_is_required
    error = assert_raises(ArgumentError) do
      FullName.new(FIRST_NAME, nil)
    end
    assert_equal error.message, 'Last name is required.'
    
    error = assert_raises(ArgumentError) do
      FullName.new(FIRST_NAME, '')
    end
    assert_equal error.message, 'Last name is required.'
  end
  
  def test_last_name_limit
    error = assert_raises(ArgumentError) do
      FullName.new(FIRST_NAME, 'Loooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooonnnng')
    end
    assert_equal error.message, 'Last name must have 50 characters or less.'
  end

  def test_last_name_characters
    error = assert_raises(ArgumentError) do
      FullName.new(FIRST_NAME, '1')
    end
    assert_equal error.message, 'Last name must be at least one character in length.'
  end
end