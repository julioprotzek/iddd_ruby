require './test/test_helper'

class EmailAddressTest < ActiveSupport::TestCase
  test 'email has address' do
    email = EmailAddress.new('zoe@example.com')
    assert_equal email.address, 'zoe@example.com'
  end

  test 'address is required' do
    error = assert_raises ArgumentError do
      EmailAddress.new('')
    end

    assert_equal error.message, 'The email address is required.'
  end

  test 'address length limit' do
    error = assert_raises ArgumentError do
      EmailAddress.new('looooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooong@example.com')
    end

    assert_equal error.message, 'The email address must be 100 characters or less.'
  end

  test 'address format' do
    error = assert_raises ArgumentError do
      EmailAddress.new('wrong email format')
    end

    assert_equal error.message, 'Email address format is invalid.'
  end

  test 'equality' do
    assert_equal EmailAddress.new('zoe@example.com'), EmailAddress.new('zoe@example.com')
    assert_not_equal EmailAddress.new('john@example.com'), EmailAddress.new('zoe@example.com')
  end
end

