import { Component, OnInit, Inject } from '@angular/core';
import {
  HeaderFooterConfigurationProvider,
  HeaderFooterConfigurationService
} from '../../configuration/header_footer/header_footer_configuration.service';
import { HeaderFooterConfigurationResource } from '../../configuration/header_footer/header_footer_configuration.resources';
import {
  FontCustomizerService,
  FontCustomizer
} from './font_customizer.service';

@Component({
  selector: 'layout-header',
  templateUrl: './header.component.html',
  styleUrls: ['./header.component.scss']
})
export class HeaderComponent implements OnInit {
  tenant_logo_file: string = '';
  tenant_url: string = '';
  marketplaceName: string = 'HRA Tool';

  constructor(
    @Inject(HeaderFooterConfigurationService.PROVIDER_TOKEN)
    private configurationProvider: HeaderFooterConfigurationProvider,
    @Inject(FontCustomizerService.PROVIDER_TOKEN)
    private fontCustomizer: FontCustomizer
  ) {}

  ngOnInit() {
    this.configurationProvider.getHeaderFooterConfiguration(this);
  }

  applyHeaderFooterConfiguration(
    resource: HeaderFooterConfigurationResource
  ): void {
    if (resource.marketplace_website_url != null) {
      this.tenant_url = resource.marketplace_website_url;
    }
    if (resource.site_logo != null) {
      this.tenant_logo_file = 'data:image/png;base64,' + resource.site_logo;
    }
    if (resource.marketplace_name != null) {
      this.marketplaceName = resource.marketplace_name;
    }
    var colors = resource.colors;
    if (colors != null) {
      if (colors.typefaces != null) {
        this.applyTypefaceConfiguration(
          colors.typeface_url,
          colors.typeface_name
        );
      }
    }
  }

  private applyTypefaceConfiguration(tfc: string, tfn: string | null) {
    this.fontCustomizer.customizeFontFromTypefaceUrl(tfc, tfn);
  }
}
