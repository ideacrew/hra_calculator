import { Component, OnInit, Inject } from '@angular/core';
import { JwtService } from '../authentication/jwt-refresh.service';
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
    private jwtService: JwtService,
    public defaultConfigService: DefaultConfigurationService
  ) {}

  ngOnInit() {
    this.hasToken = this.jwtService.hasValidToken;
    if (!this.hasToken) {
      this.jwtService.getToken();
    }
  }
}
