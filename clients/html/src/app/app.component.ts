import { Component } from '@angular/core';
import { NgbDateParserFormatter } from '@ng-bootstrap/ng-bootstrap';
import { UsDateParserFormatter } from './us_date_parser_formatter';
import { TranslateService } from '@ngx-translate/core';
import { HttpClient } from '@angular/common/http';
import { JwtRefreshService } from './authentication/jwt_refresh_service';

@Component({
  providers: [
    { provide: NgbDateParserFormatter, useClass: UsDateParserFormatter }
  ],
  selector: 'app-root',
  templateUrl: './app.component.html',
  styleUrls: ['./app.component.scss']
})
export class AppComponent {
  title = 'app';
  onActivate(event: any) {
    window.scroll(0, 0);
  }
  constructor(translate: TranslateService, private http: HttpClient) {
    // this language will be used as a fallback when a translation isn't found in the current language
    translate.setDefaultLang('en');

    // the lang to use, if the lang isn't available, it will use the current loader to get them
    translate.use(translate.getBrowserLang());
  }
  hasToken: boolean = false;
  ngOnInit() {
    var jrs = new JwtRefreshService(this.http);
    jrs.getFirstToken(this);
  }
}
