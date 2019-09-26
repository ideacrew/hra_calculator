require 'rails_helper'

describe ::Transactions::DetermineAffordability, :dbclean => :after_each do
  extend ::SettingsHelper

  before do
    DatabaseCleaner.clean
  end

  if !validate_county && !offerings_constrained_to_zip_codes
    # TODO: Refactor this to support any tenant of same kind
    let(:valid_params) do
      {
        state: 'District of Columbia', dob: '2000-10-10', household_frequency: 'annually',
        household_amount: 10000, hra_type: 'ichra', start_month: '2020-1-1', end_month: '2020-12-1',
        hra_frequency: 'monthly', hra_amount: 100
      }
    end

    let!(:product) {
      plan = FactoryBot.create(:products_health_product)
      plan.service_area.update_attributes(active_year: 2020)
      pt = plan.premium_tables.first
      pt.effective_period = Date.new(2020)..Date.new(2020,12,1)
      pt.save
      pt.rating_area.update_attributes!(active_year: 2020)
      plan.save!
      plan
    }

    context 'with valid data' do
      context 'affordable' do
        before :each do
          @determined_result ||= subject.call(valid_params.merge!(household_amount: 1000000))
        end

        it 'should be successful' do
          expect(@determined_result.success?).to be_truthy
        end

        it 'should return a value that can be formatted to json' do
          expect{@determined_result.success.to_json}.not_to raise_error
        end

        context 'for response data' do
          before do
            @result = @determined_result.success
          end

          it 'should return a value of class Hash' do
            expect(@result.class).to eq(::Hash)
          end

          it 'should return affordable per given data' do
            expect(@result[:hra_determination]).to eq(:affordable)
          end

          it 'should not have any errors for given data' do
            expect(@result[:errors]).to be_empty
          end
        end
      end

      context 'unaffordable' do
        before :each do
          @determined_result ||= subject.call(valid_params)
        end

        it 'should be successful' do
          expect(@determined_result.success?).to be_truthy
        end

        it 'should return a value that can be formatted to json' do
          expect{@determined_result.success.to_json}.not_to raise_error
        end

        context 'for response data' do
          before do
            @result = @determined_result.success
          end

          it 'should return a value of class Hash' do
            expect(@result.class).to eq(::Hash)
          end

          it 'should return unaffordable per given data' do
            expect(@result[:hra_determination]).to eq(:unaffordable)
          end

          it 'should not have any errors for given data' do
            expect(@result[:errors]).to be_empty
          end
        end
      end
    end

    context 'with invalid data' do
      let(:invalid_params) do
        {state: '', dob: '2000-10-10', household_frequency: 'annually',
          household_amount: 10000, hra_type: 'ichra', start_month: '2020-1-1', end_month: '2020-12-1',
          hra_frequency: 'monthly', hra_amount: 100
        }
      end

      before :each do
        @determined_result ||= subject.call(invalid_params)
      end

      it 'should not be successful' do
        expect(@determined_result.success?).to be_falsey
      end

      it 'should return a value that can be formatted to json' do
        expect{@determined_result.failure.to_json}.not_to raise_error
      end

      context 'for response data' do
        before do
          @result = @determined_result.failure
        end

        it 'should return a value of class Hash' do
          expect(@result.class).to eq(::Hash)
        end

        it 'should have any errors for given data' do
          expect(@result[:errors]).not_to be_empty
        end
      end
    end
  elsif validate_county && offerings_constrained_to_zip_codes
    # TODO: Refactor this to support any tenant of same kind
    let(:countyzip) { FactoryBot.create(:locations_county_zip) }

    let(:valid_params) do
      {
        state: 'Massachusetts', dob: '2000-10-10', household_frequency: 'annually',
        household_amount: 10000, hra_type: 'ichra', start_month: '2020-1-1', end_month: '2020-12-1',
        hra_frequency: 'monthly', hra_amount: 100, zipcode: countyzip.zip, county: countyzip.county_name
      }
    end

    let!(:product) {
      plan = FactoryBot.create(:products_health_product)
      plan.service_area.update_attributes(active_year: 2020, county_zip_ids: [countyzip.id])
      pt = plan.premium_tables.first
      pt.effective_period = Date.new(2020)..Date.new(2020,12,1)
      pt.save
      pt.rating_area.update_attributes!(active_year: 2020, county_zip_ids: [countyzip.id])
      plan.save!
      plan
    }

    context 'with valid data' do
      context 'affordable' do
        before :each do
          @determined_result ||= subject.call(valid_params.merge!(household_amount: 1000000))
        end

        it 'should be successful' do
          expect(@determined_result.success?).to be_truthy
        end

        it 'should return a value that can be formatted to json' do
          expect{@determined_result.success.to_json}.not_to raise_error
        end

        context 'for response data' do
          before do
            @result = @determined_result.success
          end

          it 'should return a value of class Hash' do
            expect(@result.class).to eq(::Hash)
          end

          it 'should return affordable per given data' do
            expect(@result[:hra_determination]).to eq(:affordable)
          end

          it 'should not have any errors for given data' do
            expect(@result[:errors]).to be_empty
          end
        end
      end

      context 'unaffordable' do
        before :each do
          @determined_result ||= subject.call(valid_params)
        end

        it 'should be successful' do
          expect(@determined_result.success?).to be_truthy
        end

        it 'should return a value that can be formatted to json' do
          expect{@determined_result.success.to_json}.not_to raise_error
        end

        context 'for response data' do
          before do
            @result = @determined_result.success
          end

          it 'should return a value of class Hash' do
            expect(@result.class).to eq(::Hash)
          end

          it 'should return unaffordable per given data' do
            expect(@result[:hra_determination]).to eq(:unaffordable)
          end

          it 'should not have any errors for given data' do
            expect(@result[:errors]).to be_empty
          end
        end
      end
    end

    context 'with invalid data' do
      let(:invalid_params) do
        {state: '', dob: '2000-10-10', household_frequency: 'annually',
          household_amount: 10000, hra_type: 'ichra', start_month: '2020-1-1', end_month: '2020-12-1',
          hra_frequency: 'monthly', hra_amount: 100, zipcode: '', county: ''
        }
      end

      before :each do
        @determined_result ||= subject.call(invalid_params)
      end

      it 'should not be successful' do
        expect(@determined_result.success?).to be_falsey
      end

      it 'should return a value that can be formatted to json' do
        expect{@determined_result.failure.to_json}.not_to raise_error
      end

      context 'for response data' do
        before do
          @result = @determined_result.failure
        end

        it 'should return a value of class Hash' do
          expect(@result.class).to eq(::Hash)
        end

        it 'should have any errors for given data' do
          expect(@result[:errors]).not_to be_empty
        end
      end
    end
  end

  after :all do
    DatabaseCleaner.clean
  end
end
