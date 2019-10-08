require 'rails_helper'

module Api
RSpec.describe HraResultsController, :dbclean => :after_each do
  extend ::SettingsHelper

  if !validate_county && !offerings_constrained_to_zip_codes
    context 'hra_payload' do
      context 'valid params' do
        let(:valid_params) do
          {'hra_result' => { state: 'District of Columbia', dob: '2000-10-10', household_frequency: 'annually',
            household_amount: 10000, hra_type: 'ichra', start_month: '2020-1-1', end_month: '2020-12-1',
            hra_frequency: 'monthly', hra_amount: 100
            }
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

        before do
          get :hra_payload, params: valid_params
        end

        it 'should be successful' do
          expect(response).to have_http_status(:success)
        end

        it 'should return response in JSON format' do
          expect{JSON.parse(response.body)}.not_to raise_error
        end

        context 'for response data' do
          before do
            @result = JSON.parse(response.body)
          end

          it 'should have success status' do
            expect(@result['status']).to eq('success')
          end

          it 'should have success status' do
            expect(@result['data'].class).to eq(::Hash)
          end

          it 'should return unaffordable per given data' do
            expect(@result['data']['hra_determination']).to eq('unaffordable')
          end

          it 'should not have any errors for given data' do
            expect(@result['data']['errors']).to be_empty
          end
        end
      end

      context 'invalid params' do
        let(:invalid_params) do
          {'hra_result' => { state: '', dob: '2000-10-10', household_frequency: 'annually',
            household_amount: 10000, hra_type: 'ichra', start_month: '2020-1-1', end_month: '2020-12-1',
            hra_frequency: 'monthly', hra_amount: 100
            }
          }
        end

        before do
          get :hra_payload, params: invalid_params
        end

        it 'should be successful' do
          expect(response).to have_http_status(:success)
        end

        it 'should return response in JSON format' do
          expect{JSON.parse(response.body)}.not_to raise_error
        end

        context 'for response data' do
          before do
            @result = JSON.parse(response.body)
          end

          it 'should have failure status' do
            expect(@result['status']).to eq('failure')
          end

          it 'should return data in hash format' do
            expect(@result['data'].class).to eq(::Hash)
          end
        end
      end
    end

    context 'hra_information' do
      before do
        get :hra_information
      end

      it 'should be successful' do
        expect(response).to have_http_status(:success)
      end

      it 'should return response in JSON format' do
        expect{JSON.parse(response.body)}.not_to raise_error
      end

      context 'for response data' do
        before do
          @result = JSON.parse(response.body)
        end

        it 'should have success status' do
          expect(@result['status']).to eq('success')
        end

        it 'should have success status' do
          expect(@result['data'].class).to eq(::Hash)
        end

        it 'should have all the keys for the data' do
          attr_keys = @result['data'].keys
          HraDefaulter.schema.keys.map(&:name).map(&:to_s).each do |keyy|
            expect(attr_keys.include?(keyy)).to be_truthy
          end
        end

        it 'should have all the values for the data' do
          @result['data'].values.each do |value|
            expect(value).not_to be_nil
          end
        end
      end
    end

    context 'hra_counties' do
      before do
        get :hra_counties
      end

      it 'should be successful' do
        expect(response).to have_http_status(:success)
      end

      it 'should return response in JSON format' do
        expect{JSON.parse(response.body)}.not_to raise_error
      end

      context 'for response data' do
        before do
          @result = JSON.parse(response.body)
        end

        it 'should have success status' do
          expect(@result['status']).to eq('success')
        end

        it 'should have success status' do
          expect(@result['data'].class).to eq(::Hash)
        end

        it 'should have the key for the data' do
          expect(@result['data'].keys).to eq(['counties'])
        end

        it 'should return empty array' do
          expect(@result['data'].values.first).to be_empty
        end
      end
    end
  elsif validate_county && offerings_constrained_to_zip_codes
    let(:countyzip) { FactoryBot.create(:locations_county_zip) }

    context 'hra_payload' do
      context 'valid params' do
        let(:valid_params) do
          {'hra_result' => { state: 'Massachusetts', dob: '2000-10-10', household_frequency: 'annually',
            household_amount: 10000, hra_type: 'ichra', start_month: '2020-1-1', end_month: '2020-12-1',
            hra_frequency: 'monthly', hra_amount: 100, zipcode: countyzip.zip, county: countyzip.county_name
            }
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

        before do
          get :hra_payload, params: valid_params
        end

        it 'should be successful' do
          expect(response).to have_http_status(:success)
        end

        it 'should return response in JSON format' do
          expect{JSON.parse(response.body)}.not_to raise_error
        end

        context 'for response data' do
          before do
            @result = JSON.parse(response.body)
          end

          it 'should have success status' do
            expect(@result['status']).to eq('success')
          end

          it 'should have success status' do
            expect(@result['data'].class).to eq(::Hash)
          end

          it 'should return unaffordable per given data' do
            expect(@result['data']['hra_determination']).to eq('unaffordable')
          end

          it 'should not have any errors for given data' do
            expect(@result['data']['errors']).to be_empty
          end
        end
      end

      context 'invalid params' do
        let(:invalid_params) do
          {'hra_result' => { state: '', dob: '2000-10-10', household_frequency: 'annually',
            household_amount: 10000, hra_type: 'ichra', start_month: '2020-1-1', end_month: '2020-12-1',
            hra_frequency: 'monthly', hra_amount: 100, zipcode: '', county: ''
            }
          }
        end

        before do
          get :hra_payload, params: invalid_params
        end

        it 'should be successful' do
          expect(response).to have_http_status(:success)
        end

        it 'should return response in JSON format' do
          expect{JSON.parse(response.body)}.not_to raise_error
        end

        context 'for response data' do
          before do
            @result = JSON.parse(response.body)
          end

          it 'should have failure status' do
            expect(@result['status']).to eq('failure')
          end

          it 'should return data in hash format' do
            expect(@result['data'].class).to eq(::Hash)
          end
        end
      end
    end

    context 'hra_information' do
      before do
        get :hra_information
      end

      it 'should be successful' do
        expect(response).to have_http_status(:success)
      end

      it 'should return response in JSON format' do
        expect{JSON.parse(response.body)}.not_to raise_error
      end

      context 'for response data' do
        before do
          @result = JSON.parse(response.body)
        end

        it 'should have success status' do
          expect(@result['status']).to eq('success')
        end

        it 'should have success status' do
          expect(@result['data'].class).to eq(::Hash)
        end

        it 'should have all the keys for the data' do
          attr_keys = @result['data'].keys
          HraDefaulter.schema.keys.map(&:name).map(&:to_s).each do |keyy|
            expect(attr_keys.include?(keyy)).to be_truthy
          end
        end

        it 'should have all the values for the data' do
          @result['data'].values.each do |value|
            expect(value).not_to be_nil
          end
        end
      end
    end

    context 'hra_counties' do
      let(:countyzipcode) { FactoryBot.create(:locations_county_zip) }

      before do
        get :hra_counties, params: {hra_zipcode: countyzipcode.zip.to_s}
      end

      it 'should be successful' do
        expect(response).to have_http_status(:success)
      end

      it 'should return response in JSON format' do
        expect{JSON.parse(response.body)}.not_to raise_error
      end

      context 'for response data' do
        before do
          @result = JSON.parse(response.body)
        end

        it 'should have success status' do
          expect(@result['status']).to eq('success')
        end

        it 'should have success status' do
          expect(@result['data'].class).to eq(::Hash)
        end

        it 'should have the key for the data' do
          expect(@result['data'].keys).to eq(['counties'])
        end

        it 'should have all the values for the data' do
          expect(@result['data'].values.first).to eq([countyzipcode.county_name])
        end
      end
    end
  end
end
end
