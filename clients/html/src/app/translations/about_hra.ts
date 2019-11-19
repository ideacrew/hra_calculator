export interface AboutHraTranslations {
  header: AboutHraHeaderTranslations;
  hra_type: HraTypeTranslations;
  effective_period: EffectivePeriodTranslations;
  maximum_amount: MaximumAmountTranslations;
}

interface AboutHraHeaderTranslations {
  title: string;
  paragraph: string;
}

interface HraTypeTranslations {
  header: string;
  label: string;
  description: string;
  error_required: string;
  ichra: string;
  qsehra: string;
}

interface EffectivePeriodTranslations {
  header: string;
  choose_month: string;
  start_month: MonthSelectionTranslations;
  end_month: MonthSelectionTranslations;
}

interface MonthSelectionTranslations {
  label: string;
  description: string;
  error_required: string;
}

interface MaximumAmountTranslations {
  header: string;
  description: string;
  frequency: MaximumAmountFrequencyTranslations;
  amount: MaximumAmountValueTranslations;
}

interface MaximumAmountFrequencyTranslations {
  label: string;
  description: string;
  error_required: string;
  monthly: string;
  total: string;
}

interface MaximumAmountValueTranslations {
  label: string;
  description: string;
}
