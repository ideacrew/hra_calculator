import { Component, OnInit, Inject } from '@angular/core';
import { HeaderFooterConfigurationProvider, HeaderFooterConfigurationService } from "../../configuration/header_footer/header_footer_configuration.service";
import { HeaderFooterConfigurationResource } from "../../configuration/header_footer/header_footer_configuration.resources";


@Component({
  selector: 'layout-header',
  templateUrl: './header.component.html',
  styleUrls: ['./../../app.component.scss']
})
export class HeaderComponent implements OnInit {
  tenant_logo_file: string = "";
  tenant_url: string = "";
  primaryColorCode: string;

  constructor(@Inject(HeaderFooterConfigurationService.PROVIDER_TOKEN) private configurationProvider: HeaderFooterConfigurationProvider) { 
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
    var colors = resource.colors;
    if (colors) {
      if (colors.primary_color != null) {
        this.primaryColorCode = colors.primary_color;
      }
    }
  }

}