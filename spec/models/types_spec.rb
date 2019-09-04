# frozen_string_literal: true

require "spec_helper"

RSpec.describe ::Types, :type => :model do

  let(:rails_6_month_duration)   { ActiveSupport::Duration.build(6.months) }
  let(:rails_3_day_duration)     { ActiveSupport::Duration.build(3.days) }

  describe "Types::Duration" do
    subject(:type) { Types::Duration }

    it 'responds_to Rails Duration method' do
      expect(type[rails_6_month_duration]).to respond_to :from_now
    end

    it 'definition supports callable (proc) interface' do
      expect(Types::Callable.valid?(type)).to be_truthy
    end

    it 'coerces to a Rails Duration' do
      expect(type[3.days]).to eql(rails_3_day_duration)
    end
  end

  describe "Types::LowCostPlan" do
    subject(:type)          { Types::LowCostPlan }
    let(:valid_key)         { :lowest_cost_silver_plan }
    let(:valid_key_string)  { "lowest_cost_silver_plan" }
    let(:invalid_key)       { :silly_plan }

    it 'a correct value is valid' do
      expect(type[valid_key]).to be_truthy
    end

    it 'an incorrect value is not valid' do
      expect{type[invalid_key]}.to raise_error Dry::Types::ConstraintError
    end

    it 'coerces a correct value string type to symbol' do
      expect(type[valid_key_string]).to be_truthy
    end

  end
end

