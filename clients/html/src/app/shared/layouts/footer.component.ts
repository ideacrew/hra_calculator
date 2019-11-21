import { Component, OnInit } from '@angular/core';
import { HeaderFooterConfigurationService } from '../../configuration/header_footer/header_footer_configuration.service';
import { HeaderFooterConfigurationResource } from '../../configuration/header_footer/header_footer_configuration.resources';

@Component({
  selector: 'layout-footer',
  templateUrl: './footer.component.html',
  styleUrls: ['./footer.component.scss']
})
export class FooterComponent {
  constructor(
    public footerConfigurationService: HeaderFooterConfigurationService
  ) {}
}
