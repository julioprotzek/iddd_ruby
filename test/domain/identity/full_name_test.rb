require './test/test_helper'

class FullNameTest < ActiveSupport::TestCase
  FIRST_NAME = 'Zoe'
  LAST_NAME = 'Doe'
  MARRIED_LAST_NAME = 'Jones-Doe'
  WRONG_FIRST_NAME = 'Zeo'

  test '#with_changed_first_name' do
    name = FullName.new(
      first_name: WRONG_FIRST_NAME,
      last_name: LAST_NAME
    )
    name = name.with_changed_first_name(FIRST_NAME)

    assert_equal FIRST_NAME + ' ' + LAST_NAME, name.as_formatted_name
  end

  test '#with_changed_last_name' do
    name = FullName.new(
      first_name: FIRST_NAME,
      last_name: LAST_NAME
    )
    name = name.with_changed_last_name(MARRIED_LAST_NAME)

    assert_equal FIRST_NAME + ' ' + MARRIED_LAST_NAME, name.as_formatted_name
  end

  test '#as_formatted_name' do
    name = FullName.new(
      first_name: FIRST_NAME,
      last_name: LAST_NAME
    )
    assert_equal FIRST_NAME + ' ' + LAST_NAME, name.as_formatted_name
  end

  test 'first name is required' do
    error = assert_raises(ArgumentError) do
      FullName.new(
        first_name: nil,
        last_name: LAST_NAME
      )
    end
    assert_equal error.message, 'First name is required.'

    error = assert_raises(ArgumentError) do
      FullName.new(
        first_name: '',
        last_name: LAST_NAME
      )
    end
    assert_equal error.message, 'First name is required.'
  end

  test 'first name length limit' do
    error = assert_raises(ArgumentError) do
      FullName.new(
        first_name: 'Loooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooonnnng',
        last_name: LAST_NAME
      )
    end
    assert_equal error.message, 'First name must have 50 characters or less.'
  end

  test 'first name format validation' do
    error = assert_raises(ArgumentError) do
      FullName.new(
        first_name: '1',
        last_name: LAST_NAME
      )
    end
    assert_equal error.message, 'First name must be at least one character in length, starting with a capital letter.'
  end

  test 'last name is required' do
    error = assert_raises(ArgumentError) do
      FullName.new(
        first_name: FIRST_NAME,
        last_name: nil
      )
    end
    assert_equal error.message, 'Last name is required.'

    error = assert_raises(ArgumentError) do
      FullName.new(
        first_name: FIRST_NAME,
        last_name: ''
      )
    end
    assert_equal error.message, 'Last name is required.'
  end

  test 'last name length limit' do
    error = assert_raises(ArgumentError) do
      FullName.new(
        first_name: FIRST_NAME,
        last_name: 'Loooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooonnnng'
      )
    end
    assert_equal error.message, 'Last name must have 50 characters or less.'
  end

  test 'last name format validation' do
    error = assert_raises(ArgumentError) do
      FullName.new(
        first_name: FIRST_NAME,
        last_name: '1'
      )
    end
    assert_equal error.message, 'Last name must be at least one character in length.'
  end

  test 'equality' do
    assert_equal FullName.new(
      first_name: FIRST_NAME,
      last_name: LAST_NAME
    ), FullName.new(
      first_name: FIRST_NAME,
      last_name: LAST_NAME
    )

    assert_not_equal FullName.new(
      first_name: FIRST_NAME,
      last_name: MARRIED_LAST_NAME
    ), FullName.new(
      first_name: FIRST_NAME,
      last_name: LAST_NAME
    )
  end
end