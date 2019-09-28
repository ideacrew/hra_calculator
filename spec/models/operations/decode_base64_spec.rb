require 'rails_helper'

RSpec.describe Operations::DecodeBase64, type: :model do

  it "should be a container-ready operation" do
    expect(subject.respond_to?(:call)).to be_truthy
  end

  context "binary io is passed to operation" do

    let(:value)             { "Now is the time for all good men to come to the aid of their country."}
    let(:value_as_binary)   { value.unpack("B*") }
    let(:output_as_string)  { value_as_binary.pack("B*") }

    let(:value_as_base64)   {
        "WyIwMTAwMTExMDAxMTAxMTExMDExMTAxMTEwMDEwMDAwMDAxMTAxMDAxMDExMTAwMTEwMDEwMDAwMDAxMTEwMTAwMDExMDE" +
        "wMDAwMTEwMDEwMTAwMTAwMDAwMDExMTAxMDAwMTEwMTAwMTAxMTAxMTAxMDExMDAxMDEwMDEwMDAwMDAxMTAwMTEwMDExMD" +
        "ExMTEwMTExMDAxMDAwMTAwMDAwMDExMDAwMDEwMTEwMTEwMDAxMTAxMTAwMDAxMDAwMDAwMTEwMDExMTAxMTAxMTExMDExM" + 
        "DExMTEwMTEwMDEwMDAwMTAwMDAwMDExMDExMDEwMTEwMDEwMTAxMTAxMTEwMDAxMDAwMDAwMTExMDEwMDAxMTAxMTExMDAx" + 
        "MDAwMDAwMTEwMDAxMTAxMTAxMTExMDExMDExMDEwMTEwMDEwMTAwMTAwMDAwMDExMTAxMDAwMTEwMTExMTAwMTAwMDAwMDE" + 
        "xMTAxMDAwMTEwMTAwMDAxMTAwMTAxMDAxMDAwMDAwMTEwMDAwMTAxMTAxMDAxMDExMDAxMDAwMDEwMDAwMDAxMTAxMTExMD" + 
        "ExMDAxMTAwMDEwMDAwMDAxMTEwMTAwMDExMDEwMDAwMTEwMDEwMTAxMTAxMDAxMDExMTAwMTAwMDEwMDAwMDAxMTAwMDExM" + 
        "DExMDExMTEwMTExMDEwMTAxMTAxMTEwMDExMTAxMDAwMTExMDAxMDAxMTExMDAxMDAxMDExMTAiXQ=="
      }


    it 'coercing the binary to string should work correctly' do
      expect(output_as_string).to eq value
    end

    it 'decoding the binary data should return it in string form' do
      expect(subject.call(value_as_base64.to_s).value!).to eq value_as_binary.to_s
    end

  end

end
