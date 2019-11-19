import { Component, OnInit, Inject } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { environment } from './../../environments/environment';
import {
  JwtRefreshService,
  JwtTokenRefresher
} from '../authentication/jwt_refresh_service';
import { DefaultConfigurationService } from '../default-configuration.service';

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
  }

  constructor(
    @Inject(JwtRefreshService.PROVIDER_TOKEN)
    private jwtTokenRefresher: JwtTokenRefresher,
    public defaultConfigService: DefaultConfigurationService
  ) {}

  ngOnInit() {
    this.hasToken = this.jwtTokenRefresher.hasToken();
    if (!this.hasToken) {
      this.jwtTokenRefresher.getFirstToken(this);
    }
  }
}
