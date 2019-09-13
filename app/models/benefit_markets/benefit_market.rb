module BenefitMarkets
  class BenefitMarket
    include Mongoid::Document
    include Mongoid::Timestamps

    field :site_urn,    type: String
    field :kind,        type: Symbol
    field :title,       type: String, default: ""
    field :description, type: String, default: ""

    belongs_to  :site, class_name: "::BenefitSponsors::Site", inverse_of: nil, optional: true

    has_many    :benefit_market_catalogs,
                class_name: "BenefitMarkets::BenefitMarketCatalog"
  end
end
