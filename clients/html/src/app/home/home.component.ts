import { Component, OnInit, Inject } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { environment } from './../../environments/environment';
import {
  JwtRefreshService,
  JwtTokenRefresher
} from '../authentication/jwt_refresh_service';

@Component({
  selector: 'app-home',
  templateUrl: './home.component.html',
  styleUrls: ['./home.component.scss']
})
export class HomeComponent implements OnInit {
  marketPlace: string;
  taxCredit: string;
  hostKey: string;

  private _hasToken = false;

  public get hasToken(): boolean {
    return this._hasToken;
  }

  public set hasToken(val) {
    this._hasToken = val;
    if (this._hasToken) {
      this.getInitialInfo();
    }
  }

  constructor(
    @Inject(JwtRefreshService.PROVIDER_TOKEN)
    private jwtTokenRefresher: JwtTokenRefresher,
    private httpClient: HttpClient
  ) {
    if (environment.production) {
      this.hostKey = window.location.host.split('.', 1)[0];
    } else {
      this.hostKey = 'dc';
    }
  }

  ngOnInit() {
    this.hasToken = this.jwtTokenRefresher.hasToken();
    if (!this.hasToken) {
      this.jwtTokenRefresher.getFirstToken(this);
    }
  }

  getInitialInfo() {
    this.httpClient
      .get<any>(
        environment.apiUrl +
          '/api/configurations/default_configuration?tenant=' +
          this.hostKey
      )
      .subscribe(
        res => {
          console.log(res);
          this.marketPlace = res.data.market_place;
          this.taxCredit = res.data.a_tax_credit;
        },
        err => {
          console.log(err);
        }
      );
  }
}
