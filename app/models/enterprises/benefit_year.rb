class Enterprises::BenefitYear
  include Mongoid::Document
  include Mongoid::Timestamps

  field :expected_contribution, type: Float # .0986 in 2020
  field :calendar_year, type: Integer
  field :description, type: String

  # has_many   :products,      class_name: 'Products::Product'
  # has_many   :rating_areas,  class_name: 'Locations::RatingArea'
  # has_many   :service_areas, class_name: 'Locations::ServiceArea'

  belongs_to :enterprise, class_name: 'Enterprises::Enterprise'

  validates :expected_contribution, numericality: { greater_than: 0, less_than: 1 }

end
