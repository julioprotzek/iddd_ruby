require './test/test_helper'

class TelephoneTest < Minitest::Test
  def test_create_telephone
    phone = Telephone.new('333-550-9010')
    assert_equal phone.number, '333-550-9010'
  end

  def test_number_validations
    error = assert_raises ArgumentError do
      Telephone.new('')
    end
    assert_equal error.message, 'Telephone number is required.' 
  end
end