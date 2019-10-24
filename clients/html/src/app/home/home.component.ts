import { Component, OnInit, Inject } from '@angular/core';
import { FullComponent } from '../layouts/full/full.component';
import { BlankComponent } from '../layouts/blank/blank.component';
import { HttpClient, HttpParams } from '@angular/common/http';
import { environment } from './../../environments/environment';
import { JwtRefreshService, JwtTokenRefresher } from '../authentication/jwt_refresh_service';

@Component({
  selector: 'app-home',
  templateUrl: './home.component.html',
  styleUrls: [
    './home.component.css',
    '../app.component.css'
  ]
})
export class HomeComponent implements OnInit {
  marketPlace: string;
  taxCredit: string;
  hostKey: string;
  primaryColorCode: string;
  secondaryColorCode: string;
  dangerColorCode: string;
  infoColorCode: string;
  successColorCode: string;
  warningColorCode: string;

  private _hasToken: boolean = false;

  public get hasToken() : boolean {
    return this._hasToken;
  }

  public set hasToken(val) {
    this._hasToken = val;
    if (this._hasToken) {
      this.getInitialInfo();
    }
  }

  constructor(
    @Inject(JwtRefreshService.PROVIDER_TOKEN) private jwtTokenRefresher : JwtTokenRefresher, 
    private httpClient: HttpClient
    ) {
    if (environment.production) {
      this.hostKey = window.location.host.split(".",1)[0];
    } else {
      this.hostKey = "dc";
    }
  }

  ngOnInit() {
    this.hasToken = this.jwtTokenRefresher.hasToken();
    if (!this.hasToken) {
      this.jwtTokenRefresher.getFirstToken(this);
    }
  }

  getInitialInfo() {
    this.httpClient.get<any>(environment.apiUrl+"/api/configurations/default_configuration?tenant="+this.hostKey).subscribe(
      (res) => {
        console.log(res)
        this.primaryColorCode = res.data.colors.primary_color;
        this.secondaryColorCode = res.data.colors.secondary_color;
        this.dangerColorCode = res.data.colors.danger_color;
        this.infoColorCode = res.data.colors.info_color;
        this.successColorCode = res.data.colors.success_color;
        this.warningColorCode = res.data.colors.warning_color;
        this.marketPlace = res.data.market_place;
        this.taxCredit = res.data.a_tax_credit;
      },
      (err) => {
        console.log(err)
      }
    );
  }

}
