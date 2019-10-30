import {ChangeDetectorRef, Injectable, Inject, Pipe, SecurityContext } from '@angular/core';
import { TranslatePipe, TranslateService } from '@ngx-translate/core';
import { HeaderFooterConfigurationResource } from "../configuration/header_footer/header_footer_configuration.resources";
import { HeaderFooterConfigurationProvider, HeaderFooterConfigurationService } from "../configuration/header_footer/header_footer_configuration.service";
import { DomSanitizer } from '@angular/platform-browser';

@Injectable()
@Pipe({
  name: 'tokenized_html_translate',
  pure: false // required to update the value when the promise is resolved
})
export class TokenizedHtmlTranslatePipe extends TranslatePipe {
  public benefit_year = (new Date().getFullYear() + 1).toString();
  public marketplace = "My Marketplace";

  constructor(
    private sanitizer: DomSanitizer,
    @Inject(HeaderFooterConfigurationService.PROVIDER_TOKEN) private configurationProvider: HeaderFooterConfigurationProvider,
    translate_service: TranslateService,
    _ref_value: ChangeDetectorRef) {
    super(translate_service, _ref_value);
    configurationProvider.getHeaderFooterConfiguration(this);
  }

  transform(query: string, ...args: any[]): any {
    return this.sanitizer.bypassSecurityTrustHtml(super.transform(query, {marketplace: this.marketplace, benefit_year: this.benefit_year}, ...args));
  }

  applyHeaderFooterConfiguration(resource : HeaderFooterConfigurationResource) : void {
    this.marketplace = resource.marketplace_name;
    this.benefit_year = resource.benefit_year;
  }
}