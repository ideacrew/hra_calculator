import { ChangeDetectorRef, Pipe, PipeTransform } from '@angular/core';
import { TranslatePipe, TranslateService } from '@ngx-translate/core';
import { HeaderFooterConfigurationService } from '../configuration/header_footer/header_footer_configuration.service';
import { StripTagsPipe } from 'angular-pipes';

@Pipe({
  name: 'tokenized_translate',
  pure: false // required to update the value when the promise is resolved
})
export class TokenizedTranslatePipe extends TranslatePipe
  implements PipeTransform {
  public stp = new StripTagsPipe();

  constructor(
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

    return this.stp.transform(
      super.transform(query, { marketplace, benefit_year }, ...args)
    );
  }
}
