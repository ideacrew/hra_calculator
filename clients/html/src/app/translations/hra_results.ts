export interface HraResultsTranslations {
  title: string;
  your_information: YourInformationTranslations;
  product_information: ProductInformationTranslations;
  determination_results: DeterminationResultTranslations;
  start_over_button_label: string;
  print_results_button_label: string;
  footer: string;
}

interface YourInformationTranslations {
  header: string;
  residence: string;
  date_of_birth: string;
  plan_year_household_income: string;
  plan_year_household_income_monthly: string;
  plan_year_household_income_annual: string;
  hra_type: string;
  start_date: string;
  end_date: string;
  employer_contribution: string;
  edit_info_button_label: string;
}

interface ProductInformationTranslations {
  issuer_name: string;
  product_name: string;
  hios_id: string;
  member_premium: string;
}

interface DeterminationAdviceTranslations {
  recommendation: string;
  next_steps: string;
  notice?: string;
}

interface DeterminationResultTranslations {
  your_results_header: string;
  next_steps_header: string;
  ichra_affordable: DeterminationAdviceTranslations;
  ichra_unaffordable: DeterminationAdviceTranslations;
  qsehra_affordable: DeterminationAdviceTranslations;
  qsehra_unaffordable: DeterminationAdviceTranslations;
}