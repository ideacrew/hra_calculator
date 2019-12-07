import { Component, OnInit, Inject } from '@angular/core';
import { NgbDateParserFormatter } from '@ng-bootstrap/ng-bootstrap';
import { UsDateParserFormatter } from './us_date_parser_formatter';
import { TranslateService } from '@ngx-translate/core';
import { JwtService } from './authentication/jwt-refresh.service';
import { Observable, combineLatest } from 'rxjs';
import { HeaderFooterConfigurationService } from './configuration/header_footer/header_footer_configuration.service';
import { DefaultConfigurationService } from './default-configuration.service';
import { DOCUMENT } from '@angular/common';

@Component({
  providers: [
    { provide: NgbDateParserFormatter, useClass: UsDateParserFormatter }
  ],
  selector: 'app-root',
  templateUrl: './app.component.html',
  styleUrls: ['./app.component.scss']
})
export class AppComponent implements OnInit {
  hasToken = false;
  defaultConfig$: Observable<any>;

  appVM$: Observable<any> = combineLatest([
    this.headerFooterConfigurationService.headerFooterConfigApi$,
    this.defaultConfigService.defaultConfigApi$
  ]);

  onActivate(event: any) {
    window.scroll(0, 0);
  }

  constructor(
    private translate: TranslateService,
    public jwtService: JwtService,
    public headerFooterConfigurationService: HeaderFooterConfigurationService,
    public defaultConfigService: DefaultConfigurationService,
    @Inject(DOCUMENT) private document: Document
  ) {
    // this language will be used as a fallback when a translation isn't found in the current language
    this.translate.setDefaultLang('en');

    // the lang to use, if the lang isn't available, it will use the current loader to get them
    this.translate.use(translate.getBrowserLang());
  }

  ngOnInit() {
    this.jwtService.getToken();
  }

  // https://github.com/angular/angular/issues/13636#issuecomment-332635314
  scrollToAnchor(location: string, wait: number): void {
    const element = this.document.querySelector('#' + location);
    if (element) {
      setTimeout(() => {
        element.scrollIntoView({
          behavior: 'smooth',
          block: 'start',
          inline: 'nearest'
        });
      }, wait);
    }
  }
}
