class PasswordService
  include Assertion

  STRONG_THRESHOLD = 20
  VERY_STRONG_THRESHOLD = 40

  def generate_strong_password
    SecureRandom.urlsafe_base64
  end

  def weak?(a_plain_text_password)
    calculate_strength(a_plain_text_password) < STRONG_THRESHOLD
  end

  def strong?(a_plain_text_password)
    calculate_strength(a_plain_text_password) >= STRONG_THRESHOLD
  end

  def very_strong?(a_plain_text_password)
    calculate_strength(a_plain_text_password) >= VERY_STRONG_THRESHOLD
  end

  def calculate_strength(a_plain_text_password)
    assert_not_nil(a_plain_text_password, 'Password strength cannot be tested on nil')

    strength = 0

    length = a_plain_text_password.length

    if (length > 7)
      strength += 10
      # bonus: each point, one additional
      strength += (length - 7)
    end

    digit_count = 0
    letter_count = 0
    lower_count = 0
    upper_count = 0
    symbol_count = 0

    a_plain_text_password.split('').each do |char|
      case char
      when /\d/ # digit
        digit_count += 1
      when /[A-z]/ # letter
        letter_count += 1
        if char.match?(/[a-z]/) # lowercase
          lower_count += 1
        else # uppercase
          upper_count += 1
        end
      else # symbol
        symbol_count += 1
      end
    end

    strength += (lower_count + upper_count + symbol_count)

    # bonus: letters and digits
    if letter_count > 2 && digit_count > 2
      strength += (letter_count + digit_count)
    end

    strength
  end
end