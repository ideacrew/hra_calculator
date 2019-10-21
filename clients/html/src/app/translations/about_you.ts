import { LabelDescription } from "./common";

export interface AboutYouTranslations {
  header: AboutYouHeaderTranslations;
  place_of_residence: PlaceOfResidenceTranslations;
  date_of_birth: LabelDescription;
  household_income: HouseholdIncomeTranslations;
}

interface AboutYouHeaderTranslations {
  title: string;
  paragraph: string;
  help: string;
}

interface PlaceOfResidenceTranslations {
  label: string;
  description: string;
  state: LabelDescription;
  county: LabelDescription;
  zip: LabelDescription;
}

interface HouseholdIncomeTranslations {
  label: string;
  description: string;
  frequency: IncomeFrequencyTranslations;
  amount: LabelDescription;
}

interface IncomeFrequencyTranslations {
  label: string;
  description: string;
  monthly: string;
  annual: string;
}