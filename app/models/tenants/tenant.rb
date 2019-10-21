class Tenants::Tenant
  include Mongoid::Document
  include Mongoid::Timestamps

  field :key, type: Symbol
  field :owner_organization_kind, type: String, default: 'Marketplace'
  field :owner_organization_name, type: String

  belongs_to :enterprise,
             class_name: 'Enterprises::Enterprise'

  has_many  :owner_accounts,
            class_name: 'Account'

  has_many  :products,
            class_name: 'Products::Product'

  has_many  :sites,
            class_name: 'Sites::Site'

  embeds_many :options, as: :configurable,
              class_name: 'Options::Option'

  accepts_nested_attributes_for :sites, :options

  def use_age_ratings
    features[:use_age_ratings]
  end

  def geographic_rating_area_model
    features[:rating_area_model]
  end

  def features
    return @features if defined? @features
    @features = Operations::TenantFeatures.new.call(self).success
  end

  def sites=(site_params)
    site_params.each do |site_hash|
      sites.build(site_hash)
    end
  end

  def self.find_by_key(key)
    where(key: key.to_sym).first
  end

  def consumer_portal
    sites.by_key(:consumer_portal).first
  end

  def admin_portal
    sites.by_key(:admin_portal).first
  end
end
