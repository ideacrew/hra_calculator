import { Component, OnInit, Inject } from '@angular/core';
import { HeaderFooterConfigurationService } from '../../configuration/header_footer/header_footer_configuration.service';
import { HeaderFooterConfigurationResource } from '../../configuration/header_footer/header_footer_configuration.resources';
import { FontCustomizerService } from './font_customizer.service';
import { tap } from 'rxjs/operators';
import { Observable } from 'rxjs';

@Component({
  selector: 'layout-header',
  templateUrl: './header.component.html',
  styleUrls: ['./header.component.scss']
})
export class HeaderComponent implements OnInit {
  tenant_logo_file = '';
  tenant_url = '';
  marketplaceName = 'HRA Tool';

  headerConfig$: Observable<HeaderFooterConfigurationResource>;

  constructor(
    private fontCustomizerService: FontCustomizerService,
    public configurationService: HeaderFooterConfigurationService
  ) {}

  ngOnInit() {
    this.headerConfig$ = this.configurationService.headerFooterConfig$.pipe(
      tap(config => {
        if (config.marketplace_website_url !== null) {
          this.tenant_url = config.marketplace_website_url;
        }
        if (config.site_logo != null) {
          this.tenant_logo_file = 'data:image/png;base64,' + config.site_logo;
        }
        if (config.marketplace_name != null) {
          this.marketplaceName = config.marketplace_name;
        }
        const colors = config.colors;
        if (colors != null) {
          if (colors.typefaces != null) {
            this.applyTypefaceConfiguration(
              colors.typeface_url,
              colors.typeface_name
            );
          }
        }
      })
    );
  }

  private applyTypefaceConfiguration(tfc: string, tfn: string | null) {
    this.fontCustomizerService.customizeFontFromTypefaceUrl(tfc, tfn);
  }
}
