require 'rails_helper'

RSpec.describe Operations::AgeLookup, type: :model, dbclean: :after_each do
  it 'should be a container-ready operation' do
    expect(subject.respond_to?(:call)).to be_truthy
  end

  it 'should return the matching number' do
    age = rand(14..64)
    expect(subject.call(age).success).to eq(age)
  end

  it 'should return lowest_age_for_premium_lookup' do
    age = rand(0...14)
    expect(subject.call(age).success).to eq(14)
  end

  it 'should return highest_age_for_premium_lookup' do
    age = rand(65..100)
    expect(subject.call(age).success).to eq(64)
  end
end
