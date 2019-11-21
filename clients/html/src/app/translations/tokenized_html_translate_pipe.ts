import {
  ChangeDetectorRef,
  Injectable,
  Inject,
  Pipe,
  PipeTransform
} from '@angular/core';
import { TranslatePipe, TranslateService } from '@ngx-translate/core';
import { HeaderFooterConfigurationService } from '../configuration/header_footer/header_footer_configuration.service';
import { DomSanitizer } from '@angular/platform-browser';

@Pipe({
  name: 'tokenized_html_translate',
  pure: false // required to update the value when the promise is resolved
})
export class TokenizedHtmlTranslatePipe extends TranslatePipe
  implements PipeTransform {
  constructor(
    private sanitizer: DomSanitizer,
    private headerFooterConfiguration: HeaderFooterConfigurationService,
    translate_service: TranslateService,
    _ref_value: ChangeDetectorRef
  ) {
    super(translate_service, _ref_value);
  }

  transform(query: string, ...args: any[]): any {
    const {
      benefit_year,
      marketplace
    } = this.headerFooterConfiguration.headerFooterConfig.value;

    return this.sanitizer.bypassSecurityTrustHtml(
      super.transform(query, { marketplace, benefit_year }, ...args)
    );
  }
}
