import { Component, OnInit, Inject } from '@angular/core';
import { HeaderFooterConfigurationProvider, HeaderFooterConfigurationService } from "../../configuration/header_footer/header_footer_configuration.service";
import { HeaderFooterConfigurationResource } from "../../configuration/header_footer/header_footer_configuration.resources";
import { FontCustomizerService, FontCustomizer } from './font_customizer.service';

@Component({
  selector: 'layout-header',
  templateUrl: './header.component.html',
  styleUrls: ['./../../app.component.scss']
})
export class HeaderComponent implements OnInit {
  tenant_logo_file: string = "";
  tenant_url: string = "";
  primaryColorCode: string;
  marketplaceName: string = "HRA Tool";

  constructor(
    @Inject(HeaderFooterConfigurationService.PROVIDER_TOKEN) private configurationProvider: HeaderFooterConfigurationProvider,
    @Inject(FontCustomizerService.PROVIDER_TOKEN) private fontCustomizer : FontCustomizer
    ) {
  }

  ngOnInit() {
    this.configurationProvider.getHeaderFooterConfiguration(this);
  }

  applyHeaderFooterConfiguration(resource : HeaderFooterConfigurationResource) : void {
    if (resource.marketplace_website_url != null) {
      this.tenant_url =  resource.marketplace_website_url;
    }
    if (resource.site_logo != null) {
      this.tenant_logo_file = resource.site_logo;
    }
    if (resource.marketplace_name != null) {
      this.marketplaceName = resource.marketplace_name;
    }
    var colors = resource.colors;
    if (colors != null) {
      if (colors.primary_color != null) {
        this.primaryColorCode = colors.primary_color;
      }
      if (colors.typefaces != null) {
        this.applyTypefaceConfiguration(colors.typefaces);
      }
    }
  }

  private applyTypefaceConfiguration(tfc: string) {
    this.fontCustomizer.customizeFontFromTypefaceUrl(tfc);
  }
}