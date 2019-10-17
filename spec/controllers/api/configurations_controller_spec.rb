require 'rails_helper'

RSpec.describe Api::ConfigurationsController, dbclean: :after_each do
  extend ::SettingsHelper

  if !validate_county && !offerings_constrained_to_zip_codes

    context 'default_configuration' do
      before do
        token = HraClientSession.issue
        request.headers["Authorization"] = "Bearer #{token}"
        get :default_configuration
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

    context 'counties' do
      before do
        token = HraClientSession.issue
        request.headers["Authorization"] = "Bearer #{token}"
        get :counties
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

    context 'default_configuration' do
      before do
        token = HraClientSession.issue
        request.headers["Authorization"] = "Bearer #{token}"
        get :default_configuration
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

    context 'counties' do
      let(:countyzipcode) { FactoryBot.create(:locations_county_zip) }

      before do
        token = HraClientSession.issue
        request.headers["Authorization"] = "Bearer #{token}"
        get :counties, params: {hra_zipcode: countyzipcode.zip.to_s}
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
