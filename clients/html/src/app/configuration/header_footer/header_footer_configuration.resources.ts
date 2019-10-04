interface HeaderFooterColorSettings {
  [key: string]: any;
  primary_color?: string | null;
}

export interface HeaderFooterConfigurationResource {
  [key: string]: any;
  colors?: HeaderFooterColorSettings | null;
  typeFace?: string | null;
  site_logo?: string | null;
  marketplace_name?: string;
  marketplace_website_url?: string | null;
}