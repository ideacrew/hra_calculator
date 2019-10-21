import { AboutYouTranslations } from "./about_you";
import { AboutHraTranslations } from "./about_hra";
import { CardTranslations } from "./common";
import { HraResultsTranslations } from "./hra_results";

export interface TranslationDictionary {
  site: SiteTranslations;
  getting_started: GettingStartedTranslations;
  about_you: AboutYouTranslations;
  about_hra: AboutHraTranslations;
  hra_results: HraResultsTranslations;
}

export interface SiteTranslations {
  title: string;
  customer_support: string;
  benefit_year: string;
  button_previous_label: string;
  button_next_label: string;
}

export interface GettingStartedTranslations {
  title: string;
  paragraph_1: string;
  paragraph_2: string;
  disclaimer: string;
  use_if: CardTranslations;
  do_not_use_if: CardTranslations;
  start_button_label: string;
}