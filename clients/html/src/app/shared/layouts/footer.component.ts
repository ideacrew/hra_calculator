import { Component, OnInit, Inject } from '@angular/core';
import {
  HeaderFooterConfigurationProvider,
  HeaderFooterConfigurationService
} from '../../configuration/header_footer/header_footer_configuration.service';
import { HeaderFooterConfigurationResource } from '../../configuration/header_footer/header_footer_configuration.resources';

@Component({
  selector: 'layout-footer',
  templateUrl: './footer.component.html',
  styleUrls: ['./footer.component.scss']
})
export class FooterComponent implements OnInit {
  customer_support_number: String;
  benefit_year: number;
  today: number = Date.now();

  constructor(
    @Inject(HeaderFooterConfigurationService.PROVIDER_TOKEN)
    private configurationProvider: HeaderFooterConfigurationProvider
  ) {
    this.benefit_year = new Date().getFullYear() + 1;
  }

  ngOnInit() {
    this.getInitialInfo();
  }

  getInitialInfo() {
    this.configurationProvider.getHeaderFooterConfiguration(this);
  }

  applyHeaderFooterConfiguration(
    resource: HeaderFooterConfigurationResource
  ): void {
    if (resource.call_center_phone != null) {
      this.customer_support_number = resource.call_center_phone;
    }
  }
}
