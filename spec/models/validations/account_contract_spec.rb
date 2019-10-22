require 'rails_helper'

RSpec.describe Validations::AccountContract, type: :model, dbclean: :after_each do
  let(:params) do
    { email: 'email@uu.com', password: 'ChangeMe!', role: 'Role' }
  end

  context 'for success case' do
    before do
      @result = subject.call(params)
    end

    it 'should be a container-ready operation' do
      expect(subject.respond_to?(:call)).to be_truthy
    end

    it 'should return Dry::Validation::Result object' do
      expect(@result).to be_a ::Dry::Validation::Result
    end

    it 'should not return any errors' do
      expect(@result.errors.to_h).to be_empty
    end
  end

  context 'for failure case' do
    before do
      @result = subject.call({ email: 'email@uu.com', role: :roleeee })
    end

    it 'should return any errors' do
      expect(@result.errors.to_h).not_to be_empty
    end

    it 'should return any errors' do
      expect(@result.errors.to_h).to eq({ :password=>["is missing"], :role=>["must be a string"] })
    end
  end
end
