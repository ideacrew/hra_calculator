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

  def offerings_constrained_to_zip_codes
    Registry['enterprise.dchbx.primary.production.offerings_constrained_to_zip_codes']
  end

  def state_full_name
    Registry['enterprise.dchbx.primary.production.state_full_name']
  end

  def state_abbreviation
    Registry['enterprise.dchbx.primary.production.state_abbr']
  end

  def tax_credit
    Registry['enterprise.dchbx.primary.production.tax_credit']
  end

  def market_place
    Registry['enterprise.dchbx.primary.production.market_place']
  end

  def help_text_1
    Registry['enterprise.dchbx.primary.production.help_text_1']
  end

  def help_text_2
    Registry['enterprise.dchbx.primary.production.help_text_2']
  end

  def short_term_plan
    Registry['enterprise.dchbx.primary.production.short_term_plan']
  end

  def minimum_essential_coverage
    Registry['enterprise.dchbx.primary.production.minimum_essential_coverage']
  end

  def minimum_essential_coverage_link
    Registry['enterprise.dchbx.primary.production.minimum_essential_coverage_link']
  end

  def enroll_without_aptc
    Registry['enterprise.dchbx.primary.production.enroll_without_aptc']
  end

  def help_text_3
    Registry['enterprise.dchbx.primary.production.help_text_3']
  end

  def help_text_4
    Registry['enterprise.dchbx.primary.production.help_text_4']
  end
end
