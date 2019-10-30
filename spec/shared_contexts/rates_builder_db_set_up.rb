# frozen_string_literal: true

RSpec.shared_context 'setup rating areas and products for ma', shared_context: :metadata do
  let!(:ra1) {FactoryBot.create(:locations_rating_area, active_year: year, exchange_provided_code: 'Rating Area 1')}
  let!(:ra2) {FactoryBot.create(:locations_rating_area, active_year: year, exchange_provided_code: 'Rating Area 2')}
  let!(:ra3) {FactoryBot.create(:locations_rating_area, active_year: year, exchange_provided_code: 'Rating Area 3')}
  let!(:ra4) {FactoryBot.create(:locations_rating_area, active_year: year, exchange_provided_code: 'Rating Area 4')}
  let!(:ra5) {FactoryBot.create(:locations_rating_area, active_year: year, exchange_provided_code: 'Rating Area 5')}
  let!(:ra6) {FactoryBot.create(:locations_rating_area, active_year: year, exchange_provided_code: 'Rating Area 6')}
  let!(:ra7) {FactoryBot.create(:locations_rating_area, active_year: year, exchange_provided_code: 'Rating Area 7')}
  let!(:application_period) { Time.utc(year)..Time.utc(year).end_of_year }
  let!(:previous_application_period) { Time.utc(year - 1)..Time.utc(year - 1).end_of_year }

  let!(:hp1) { FactoryBot.create(:products_health_product, application_period: application_period, hios_id: '42690MA1250012-01', hios_base_id: '42690MA1250012', csr_variant_id: '01', tenant: tenant) }
  let!(:hp2) { FactoryBot.create(:products_health_product, application_period: application_period, hios_id: '42690MA1290012-01', hios_base_id: '42690MA1290012', csr_variant_id: '01', tenant: tenant) }

  let!(:hp11) { FactoryBot.create(:products_health_product, application_period: previous_application_period, hios_id: '42690MA1250012-01', hios_base_id: '42690MA1250012', csr_variant_id: '01', tenant: tenant) }
  let!(:hp21) { FactoryBot.create(:products_health_product, application_period: previous_application_period, hios_id: '42690MA1290012-01', hios_base_id: '42690MA1290012', csr_variant_id: '01', tenant: tenant) }
end

RSpec.shared_context 'setup rating areas and products for ny', shared_context: :metadata do
  let!(:ra1) {FactoryBot.create(:locations_rating_area, active_year: year, exchange_provided_code: 'Rating Area 2')}
  let!(:application_period) { Time.utc(year)..Time.utc(year).end_of_year }
  let!(:previous_application_period) { Time.utc(year - 1)..Time.utc(year - 1).end_of_year }

  let!(:hp1) { FactoryBot.create(:products_health_product, application_period: application_period, hios_id: '49526NY0450001-01', hios_base_id: '49526NY0450001', csr_variant_id: '01', tenant: tenant) }
  let!(:hp2) { FactoryBot.create(:products_health_product, application_period: application_period, hios_id: '49526NY0450002-01', hios_base_id: '49526NY0450002', csr_variant_id: '01', tenant: tenant) }

  let!(:hp11) { FactoryBot.create(:products_health_product, application_period: previous_application_period, hios_id: '49526NY0450001-01', hios_base_id: '49526NY0450001', csr_variant_id: '01', tenant: tenant) }
  let!(:hp21) { FactoryBot.create(:products_health_product, application_period: previous_application_period, hios_id: '49526NY0450002-01', hios_base_id: '49526NY0450002', csr_variant_id: '01', tenant: tenant) }

  let(:countyzips) do
    czs = ::Locations::CountyZip.all
    czs.each { |cz| cs.update_attributes!(zip: nil, states: ['NY'])}
    czs
  end
end

RSpec.shared_context 'setup products for dc', shared_context: :metadata do
  let!(:application_period) { Time.utc(year)..Time.utc(year).end_of_year }
  let!(:previous_application_period) { Time.utc(year - 1)..Time.utc(year - 1).end_of_year }

  let!(:hp1) do
    hp = FactoryBot.create(:products_health_product, application_period: application_period, hios_id: '42690MA1250012-01', hios_base_id: '42690MA1250012', csr_variant_id: '01', tenant: tenant)
    hp.update_attributes!(service_area_id: nil)
    hp.premium_tables.each { |pt| pt.update_attributes!(rating_area_id: nil)}
  end
  let!(:hp2) do
    hp = FactoryBot.create(:products_health_product, application_period: application_period, hios_id: '42690MA1290012-01', hios_base_id: '42690MA1290012', csr_variant_id: '01', tenant: tenant)
    hp.update_attributes!(service_area_id: nil)
    hp.premium_tables.each { |pt| pt.update_attributes!(rating_area_id: nil)}
  end

  let!(:hp11) do
    hp = FactoryBot.create(:products_health_product, application_period: previous_application_period, hios_id: '42690MA1250012-01', hios_base_id: '42690MA1250012', csr_variant_id: '01', tenant: tenant)
    hp.update_attributes!(service_area_id: nil)
    hp.premium_tables.each { |pt| pt.update_attributes!(rating_area_id: nil)}
  end

  let!(:hp21) do
    hp = FactoryBot.create(:products_health_product, application_period: previous_application_period, hios_id: '42690MA1290012-01', hios_base_id: '42690MA1290012', csr_variant_id: '01', tenant: tenant)
    hp.update_attributes!(service_area_id: nil)
    hp.premium_tables.each { |pt| pt.update_attributes!(rating_area_id: nil)}
  end
end

