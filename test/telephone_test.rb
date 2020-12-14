require './test/test_helper'

class TelephoneTest < Minitest::Test
  def test_create_telephone
    phone = Telephone.new('333-550-9010')
    assert_equal phone.number, '333-550-9010'
  end

  def test_number_is_required
    error = assert_raises ArgumentError do
      Telephone.new('')
    end
    assert_equal error.message, 'Telephone number is required.' 
  end

  def test_number_length_limit
    error = assert_raises ArgumentError do
      Telephone.new('100200300400500600700800900-100200300400500600700800900')
    end
    assert_equal error.message, 'Telephone number may not be more than 20 characters.' 
  end

  def test_number_format_validation
    phone = Telephone.new('(123) 200-30040')
    assert_equal phone.number, '(123) 200-30040'

    error = assert_raises ArgumentError do
      Telephone.new('12313123123123')
    end
    assert_equal error.message, 'Telephone number or its format is invalid.' 
  end
end