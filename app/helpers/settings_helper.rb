module SettingsHelper
  def offerings_constrained_to_service_areas
    Registry['enterprise.dchbx.primary.production.offerings_constrained_to_service_areas']
  end

  def offerings_constrained_to_rating_areas
    Registry['enterprise.dchbx.primary.production.offerings_constrained_to_rating_areas']
  end

  def validate_county
    Registry['enterprise.dchbx.primary.production.validate_county']
  end

  def validate_zipcode
    Registry['enterprise.dchbx.primary.production.validate_zipcode']
  end

  def state_full_name
    Registry['enterprise.dchbx.primary.production.state_full_name']
  end

  def state_abbreviation
    Registry['enterprise.dchbx.primary.production.state_abbr']
  end
end
