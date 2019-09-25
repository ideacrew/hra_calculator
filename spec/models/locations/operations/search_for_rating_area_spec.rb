require 'rails_helper'

describe ::Locations::Operations::SearchForRatingArea, :dbclean => :after_each do
  before do
    DatabaseCleaner.clean
  end

  context 'invalid' do
  end

  after :all do
    DatabaseCleaner.clean
  end
end
