module BenefitSponsors
  class Site
    include Mongoid::Document
    include Mongoid::Timestamps
    field :site_key,    type: Symbol
    field :long_name,   type: String
    field :short_name,  type: String

    has_one   :owner_organization, inverse_of: :site_owner,
              class_name: "BenefitSponsors::Organizations::ExemptOrganization"

    has_many :benefit_markets, inverse_of: :site,
             class_name: "::BenefitMarkets::BenefitMarket"
  end
end
