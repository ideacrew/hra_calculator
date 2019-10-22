import { LabelDescription } from "./common";

export interface AboutYouTranslations {
  header: AboutYouHeaderTranslations;
  place_of_residence: PlaceOfResidenceTranslations;
  date_of_birth: DateOfBirthTranslations;
  household_income: HouseholdIncomeTranslations;
}

interface DateOfBirthTranslations {
  header: string;
  label: string;
  description: string;
  error_required: string;
  error_range: string;
  error_format: string;
}

interface AboutYouHeaderTranslations {
  title: string;
  paragraph: string;
  help: string;
}

interface PlaceOfResidenceTranslations {
  header: string;
  description: string;
  state: StatePlaceOfResidenceTranslations;
  county: CountyOfResidenceTranslations;
  zip: ZipPlaceOfResidenceTranslations;
}

interface StatePlaceOfResidenceTranslations {
  label: string;
  description: string;
  error_required: string;
}

interface ZipPlaceOfResidenceTranslations {
  label: string;
  description: string;
  error_required: string;
  error_length: string;
}

interface CountyOfResidenceTranslations {
  label: string;
  description: string;
  error_required: string;
}

interface HouseholdIncomeTranslations {
  header: string;
  description: string;
  frequency: IncomeFrequencyTranslations;
  amount: IncomeAmountTranslations;
}

interface IncomeFrequencyTranslations {
  label: string;
  description: string;
  error_required: string;
  monthly: string;
  annual: string;
}

interface IncomeAmountTranslations {
  label: string;
  description: string;
  error_required: string;
}