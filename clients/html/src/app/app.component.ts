import { Component, OnInit } from '@angular/core';
import { NgbDateParserFormatter } from '@ng-bootstrap/ng-bootstrap';
import { UsDateParserFormatter } from './us_date_parser_formatter';
import { TranslateService } from '@ngx-translate/core';
import { HttpClient } from '@angular/common/http';
import { JwtRefreshService } from './authentication/jwt_refresh_service';
import { environment } from 'src/environments/environment';
import { CustomColorsService } from './custom-colors.service';
import { tap } from 'rxjs/operators';
import { Observable } from 'rxjs';
import { HeaderFooterConfigurationService } from './configuration/header_footer/header_footer_configuration.service';
import { DefaultConfigurationService } from './default-configuration.service';

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

  onActivate(event: any) {
    window.scroll(0, 0);
  }

  constructor(
    translate: TranslateService,
    private http: HttpClient,
    public headerFooterConfigurationService: HeaderFooterConfigurationService,
    public defaultConfigService: DefaultConfigurationService
  ) {
    // this language will be used as a fallback when a translation isn't found in the current language
    translate.setDefaultLang('en');

    // the lang to use, if the lang isn't available, it will use the current loader to get them
    translate.use(translate.getBrowserLang());
  }

  ngOnInit() {
    const jrs = new JwtRefreshService(this.http);
    jrs.getFirstToken(this);
  }
}
