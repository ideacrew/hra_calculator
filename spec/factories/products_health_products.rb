FactoryBot.define do
  factory :products_health_product, class: '::Products::HealthProduct' do

    benefit_market_kind  { :aca_individual }
    application_period   { Date.new(Date.today.year, 1, 1)..Date.new(Date.today.year, 12, 31) }
    sequence(:title)     { |n| "#{issuer_name} #{metal_level_kind}#{n} 2,000" }
    health_plan_kind     { :pos }
    ehb                  { 0.9943 }
    metal_level_kind     { :silver }
    product_package_kinds { [:single_product, :single_issuer, :metal_level] }
    sequence(:hios_id, (10..99).cycle)  { |n| "41842DC04000#{n}-01" }

    service_area { create(:locations_service_area) }

    transient do
      issuer_name { 'BlueChoice' }
    end

    trait :next_year do
      application_period do
        year = Time.zone.today.next_year.year
        Date.new(year, 1, 1)..Date.new(year, 12, 31)
      end
    end

    trait :csr_87 do
      metal_level_kind        { :silver }
      benefit_market_kind     { :aca_individual }
      csr_variant_id          { "87" }
    end

    trait :csr_00 do
      metal_level_kind        { :silver }
      benefit_market_kind     { :aca_individual }
      csr_variant_id          { "00" }
    end

    trait :catastrophic do
      metal_level_kind        { :catastrophic }
      benefit_market_kind     { :aca_individual }
    end

    trait :gold do
      metal_level_kind        { :gold }
      benefit_market_kind     { :aca_individual }
    end

    trait :silver do
      metal_level_kind        { :silver }
      benefit_market_kind     { :aca_individual }
    end

    after(:build) do |product, evaluator|
      product.premium_tables << build_list(:products_premium_table, 1, effective_period: product.application_period)
    end
  end
end
