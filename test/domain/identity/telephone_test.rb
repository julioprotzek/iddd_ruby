require './test/test_helper'

class TelephoneTest < ActiveSupport::TestCase
  test 'telephone has number' do
    phone = PhoneNumber.new('333-550-9010')
    assert_equal phone.number, '333-550-9010'
  end

  test 'number is required' do
    error = assert_raises ArgumentError do
      PhoneNumber.new('')
    end
    assert_equal error.message, 'PhoneNumber number is required.'
  end

  test 'number length limit' do
    error = assert_raises ArgumentError do
      PhoneNumber.new('100200300400500600700800900-100200300400500600700800900')
    end
    assert_equal error.message, 'PhoneNumber number may not be more than 20 characters.'
  end

  test 'number format validation' do
    phone = PhoneNumber.new('(123) 200-30040')
    assert_equal phone.number, '(123) 200-30040'

    error = assert_raises ArgumentError do
      PhoneNumber.new('12313123123123')
    end
    assert_equal error.message, 'PhoneNumber number or its format is invalid.'
  end

  test 'equality' do
    assert_equal PhoneNumber.new('(123) 200-30040'), PhoneNumber.new('(123) 200-30040')
    assert_not_equal PhoneNumber.new('333-550-9010'), PhoneNumber.new('(123) 200-30040')
  end
end