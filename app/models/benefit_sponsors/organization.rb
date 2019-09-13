module BenefitSponsors
  class Organization
    include Mongoid::Document
    include Mongoid::Timestamps

    field :legal_name, type: String
    field :dba, type: String
    field :fein, type: String

    belongs_to  :site, inverse_of: :site_organizations, counter_cache: true,
                class_name: "::BenefitSponsors::Site",
                optional: true
  end
end
