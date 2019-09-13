module BenefitMarkets
  class BenefitMarketCatalog
    include Mongoid::Document
    include Mongoid::Timestamps

    field :application_interval_kind,  type: Symbol
    field :application_period,          type: Range
    field :title,                       type: String, default: ""
    field :description,                 type: String, default: ""

    belongs_to  :benefit_market,
                class_name: "::BenefitMarkets::BenefitMarket",
                optional: true

    has_and_belongs_to_many  :service_areas,
                              class_name: "::BenefitMarkets::Locations::ServiceArea"
  end
end
