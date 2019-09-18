module SettingsHelper
  def offerings_constrained_to_service_areas
    Registry['enterprise.dchbx.primary.production.offerings_constrained_to_service_areas']
  end

  def validate_county
    Registry['enterprise.dchbx.primary.production.validate_county']
  end
end