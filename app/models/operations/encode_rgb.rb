# Transforms an array with three-part color values encoded in base10 to single hexadecimal value
class Operations::EncodeRgb
  include Dry::Transaction::Operation

  def call(input)
    Success(encode(input))
  end

  def encode(colors)
    colors.each_with_object("") do |part, to_hex|
      channel = restrict_to_range(part).to_s(16)
      channel = 0.to_s + channel if channel.length == 1
      to_hex << channel
    end
  end

  def restrict_to_range(part)
    [[0, part].max, 255].min
  end

end
