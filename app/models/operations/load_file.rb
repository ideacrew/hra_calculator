# frozen_string_literal: true

class Operations::LoadFile
  include Dry::Transaction::Operation

  def call(input)
    Success(IO.read(File.open(input)))
  end

end