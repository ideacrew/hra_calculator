module SettingsHelper
  # TODO: read the following from Registries
  def offerings_constrained_to_service_areas
    false
    # Registry['enterprise.dchbx.primary.production.offerings_constrained_to_service_areas']
  end

  def offerings_constrained_to_rating_areas
    false
    # Registry['enterprise.dchbx.primary.production.offerings_constrained_to_rating_areas']
  end

  def validate_county
    false
    # Registry['enterprise.dchbx.primary.production.validate_county']
  end

  def offerings_constrained_to_zip_codes
    false
    # Registry['enterprise.dchbx.primary.production.offerings_constrained_to_zip_codes']
  end

  def state_full_name
    'District of Columbia'
    # Registry['enterprise.dchbx.primary.production.state_full_name']
  end

  def state_abbreviation
    'DC'
    # Registry['enterprise.dchbx.primary.production.state_abbr']
  end

  def tax_credit
    'a tax credit'
    # Registry['enterprise.dchbx.primary.production.tax_credit']
  end

  def market_place
    'MARKETPLACE'
    # Registry['enterprise.dchbx.primary.production.market_place']
  end

  def help_text_1
    "Answer 'no' when asked if you're offered health insurance by an employer (unless you are separately offered health insurance by another employer)."
    # Registry['enterprise.dchbx.primary.production.help_text_1']
  end

  def help_text_2
    "When you're asked to set your tax credit amount, reduce what you accept by your monthly HRA amount to help avoid having to pay back money at tax time."
    # Registry['enterprise.dchbx.primary.production.help_text_2']
  end

  def short_term_plan
    'such as a short-term plan'
    # Registry['enterprise.dchbx.primary.production.short_term_plan']
  end

  def minimum_essential_coverage
    'minimum essential coverage'
    # Registry['enterprise.dchbx.primary.production.minimum_essential_coverage']
  end

  def minimum_essential_coverage_link
    "https://www.healthcare.gov/fees/plans-that-count-as-coverage/"
    # Registry['enterprise.dchbx.primary.production.minimum_essential_coverage_link']
  end

  def enroll_without_aptc
    'HOW TO ENROLL THROUGH MARKETPLACE WITHOUT APTC'
    # Registry['enterprise.dchbx.primary.production.enroll_without_aptc']
  end

  def help_text_3
    'similar coverage off Marketplace.'
    # Registry['enterprise.dchbx.primary.production.help_text_3']
  end

  def help_text_4
    'an ACA-compliant plan off Marketplace. Ask your employer about your options.'
    # Registry['enterprise.dchbx.primary.production.help_text_4']
  end

  def help_text_5
    "[The results above are based on the information provided, which has not been independently verified. This is not a determination that you are eligible for a tax credit.]"
  end

  def help_text_5
    "[The results above are based on the information provided, which has not been independently verified. This is not a determination that you are eligible for a tax credit.]"
    # Registry['enterprise.dchbx.primary.production.help_text_5']
  end
end
