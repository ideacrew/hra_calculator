import { NgModule } from '@angular/core';
import { BrowserModule } from '@angular/platform-browser';
import { BrowserAnimationsModule } from '@angular/platform-browser/animations';
import { CommonModule} from '@angular/common';
import { HttpClientModule } from '@angular/common/http';

import { HeaderComponent } from './header.component';
import { FooterComponent } from './footer.component';

import { HeaderFooterConfigurationService } from "../../configuration/header_footer/header_footer_configuration.service";
import { FontCustomizerService } from "./font_customizer.service";

@NgModule({
  declarations: [
    HeaderComponent,
    FooterComponent
  ],
  imports: [
    CommonModule,
    BrowserModule,
    BrowserAnimationsModule,
    HttpClientModule
  ],
  providers: [
    HeaderFooterConfigurationService.providers(),
    FontCustomizerService.providers()
  ],
  exports: [
    HeaderComponent,
    FooterComponent
  ]
})
export class LayoutsModule { }