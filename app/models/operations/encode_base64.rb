# Transforms an array with three-part color values encoded in base10 to single hexadecimal value

class Operations::EncodeBase64
  include Dry::Transaction::Operation

  def call(input)
    Success(encode(input))
  end

  def encode(string)
    Base64.strict_encode64(string)
  end

end
