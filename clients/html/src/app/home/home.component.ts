import { Component, OnInit } from '@angular/core';
import { FullComponent } from '../layouts/full/full.component';
import { BlankComponent } from '../layouts/blank/blank.component';
import { HttpClient, HttpParams } from '@angular/common/http';
import { environment } from './../../environments/environment';

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

  constructor(private httpClient: HttpClient,) {
    if (environment.production) {
      this.hostKey = window.location.host.split(".",1)[0];
    } else {
      this.hostKey = "dc";
    }
  }

  ngOnInit() {
    this.getInitialInfo();
  }

  getInitialInfo() {
    this.httpClient.get<any>(environment.apiUrl+"/api/configurations/default_configuration?tenant="+this.hostKey).subscribe(
      (res) => {
        console.log(res)
        this.marketPlace = res.data.market_place;
        this.taxCredit = res.data.tax_credit;
      },
      (err) => {
        console.log(err)
      }
    );
  }

}
