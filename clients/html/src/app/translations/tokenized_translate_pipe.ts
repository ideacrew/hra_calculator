import {ChangeDetectorRef, Injectable, Inject, Pipe, SecurityContext } from '@angular/core';
import { TranslatePipe, TranslateService } from '@ngx-translate/core';
import { HeaderFooterConfigurationResource } from "../configuration/header_footer/header_footer_configuration.resources";
import { HeaderFooterConfigurationProvider, HeaderFooterConfigurationService } from "../configuration/header_footer/header_footer_configuration.service";

@Injectable()
@Pipe({
  name: 'tokenized_translate',
  pure: false // required to update the value when the promise is resolved
})
export class TokenizedTranslatePipe extends TranslatePipe {
  public benefit_year = (new Date().getFullYear() + 1).toString();
  public marketplace = "My Marketplace";

  constructor(
    @Inject(HeaderFooterConfigurationService.PROVIDER_TOKEN) private configurationProvider: HeaderFooterConfigurationProvider,
    translate_service: TranslateService,
    _ref_value: ChangeDetectorRef) {
    super(translate_service, _ref_value);
    configurationProvider.getHeaderFooterConfiguration(this);
  }

  transform(query: string, ...args: any[]): any {
    return super.transform(query, {marketplace: this.marketplace, benefit_year: this.benefit_year}, ...args);
  }

  applyHeaderFooterConfiguration(resource : HeaderFooterConfigurationResource) : void {
    this.marketplace = resource.marketplace_name;
    this.benefit_year = resource.benefit_year;
  }
}