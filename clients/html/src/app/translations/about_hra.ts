import { LabelDescription } from "./common";

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
  label: string;
  choice: HraTypeChoiceTranslations;
}

interface HraTypeChoiceTranslations {
  label: string;
  description: string;
  ichra: string;
  qsehra: string;
}

interface EffectivePeriodTranslations {
  label: string;
  start_month: LabelDescription;
  end_month: LabelDescription;
}

interface MaximumAmountTranslations {
  label: string;
  description: string;
  frequency: MaximumAmountFrequencyTranslations;
  amount: MaximumAmountValueTranslations;
}

interface MaximumAmountFrequencyTranslations {
  label: string;
  description: string;
  monthly: string;
  total: string;
}

interface MaximumAmountValueTranslations {
  label: string;
  description: string;
}