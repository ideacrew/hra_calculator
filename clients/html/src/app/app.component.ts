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

@Component({
  providers: [
    { provide: NgbDateParserFormatter, useClass: UsDateParserFormatter }
  ],
  selector: 'app-root',
  templateUrl: './app.component.html',
  styleUrls: ['./app.component.scss']
})
export class AppComponent implements OnInit {
  title = 'app';
  hostKey: string;
  hasToken = false;
  defaultConfig$: Observable<any>;

  onActivate(event: any) {
    window.scroll(0, 0);
  }

  constructor(
    translate: TranslateService,
    private http: HttpClient,
    private colorService: CustomColorsService
  ) {
    // this language will be used as a fallback when a translation isn't found in the current language
    translate.setDefaultLang('en');

    // the lang to use, if the lang isn't available, it will use the current loader to get them
    translate.use(translate.getBrowserLang());

    if (environment.production) {
      this.hostKey = window.location.host.split('.', 1)[0];
    } else {
      this.hostKey = 'dc';
    }

    this.defaultConfig$ = this.http
      .get<any>(
        environment.apiUrl +
          '/api/configurations/default_configuration?tenant=' +
          this.hostKey
      )
      .pipe(
        tap(res => this.colorService.registerCustomColors(res.data.colors))
      );
  }

  ngOnInit() {
    const jrs = new JwtRefreshService(this.http);
    jrs.getFirstToken(this);
  }
}
