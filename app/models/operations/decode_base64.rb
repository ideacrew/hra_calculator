# Transforms an array with three-part color values encoded in base10 to single hexadecimal value

class Operations::DecodeBase64
  include Dry::Transaction::Operation

  def call(input)
    Success(decode(input))
  end

  def decode(encoded_string)
    Base64.urlsafe_decode64(encoded_string)
  end

end
