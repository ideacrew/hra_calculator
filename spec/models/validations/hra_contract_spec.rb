require 'rails_helper'

RSpec.describe Validations::HraContract, type: :model, dbclean: :after_each do

  let(:valid_params) do
    {
      tenant: :dc, state: 'District of Columbia', dob: '2000-10-10', household_frequency: 'annually',
      household_amount: 10000, hra_type: 'ichra', start_month: '2020-1-1', end_month: '2020-12-1',
      hra_frequency: 'monthly', hra_amount: 100
    }
  end

  context 'for success case' do
    before do
      @result = subject.call(valid_params)
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

  context 'for failure cases' do
    context 'missing key' do
      before do
        @result = subject.call(valid_params.except(:household_frequency))
      end

      it 'should return any errors' do
        expect(@result.errors.to_h).not_to be_empty
      end

      it 'should return any errors' do
        expect(@result.errors.to_h).to eq({ :household_frequency=>['is missing'] })
      end
    end

    context 'end_month less than start_month' do
      let(:valid_params) do
        {
          tenant: :dc, state: 'District of Columbia', dob: '2000-10-10', household_frequency: 'annually',
          household_amount: 10000, hra_type: 'ichra', start_month: '2020-12-1', end_month: '2020-1-1',
          hra_frequency: 'monthly', hra_amount: 100
        }
      end

      before do
        @result = subject.call(valid_params)
      end

      it 'should return any errors' do
        expect(@result.errors.to_h).not_to be_empty
      end

      it 'should return any errors' do
        expect(@result.errors.to_h).to eq({ :end_month=>['must be after start_month'] })
      end
    end

    context 'bad hra_type' do
      before do
        @result = subject.call(valid_params.merge!({hra_type: 'hra_type'}))
      end

      it 'should return any errors' do
        expect(@result.errors.to_h).not_to be_empty
      end

      it 'should return any errors' do
        expect(@result.errors.to_h).to eq({ :hra_type=>['must be ichra/qsehra'] })
      end
    end

    context 'bad household_frequency' do
      before do
        @result = subject.call(valid_params.merge!({household_frequency: 'household_frequency'}))
      end

      it 'should return any errors' do
        expect(@result.errors.to_h).not_to be_empty
      end

      it 'should return any errors' do
        expect(@result.errors.to_h).to eq({ :household_frequency=>['should be either monthly or annually'] })
      end
    end

    context 'bad hra_frequency' do
      before do
        @result = subject.call(valid_params.merge!({hra_frequency: 'hra_frequency'}))
      end

      it 'should return any errors' do
        expect(@result.errors.to_h).not_to be_empty
      end

      it 'should return any errors' do
        expect(@result.errors.to_h).to eq({ :hra_frequency=>['should be either monthly or annually'] })
      end
    end

    context 'bad hra_amount' do
      before do
        @result = subject.call(valid_params.merge!({hra_amount: -100.0}))
      end

      it 'should return any errors' do
        expect(@result.errors.to_h).not_to be_empty
      end

      it 'should return any errors' do
        expect(@result.errors.to_h).to eq({ :hra_amount=>['should be valid and positive'] })
      end
    end

    context 'bad household_amount' do
      before do
        @result = subject.call(valid_params.merge!({household_amount: -100.0}))
      end

      it 'should return any errors' do
        expect(@result.errors.to_h).not_to be_empty
      end

      it 'should return any errors' do
        expect(@result.errors.to_h).to eq({ :household_amount=>['should be valid and positive'] })
      end
    end
  end
end
