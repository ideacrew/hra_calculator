import { Component, OnInit } from '@angular/core';
import { HttpClient, HttpParams } from '@angular/common/http';
import { environment } from './../../../environments/environment';

@Component({
  selector: 'layout-header',
  templateUrl: './header.component.html',
  styleUrls: ['./../../app.component.scss']
})
export class HeaderComponent implements OnInit {
  tenant_logo_file: string;
  tenant_url: string;
  hostKey: string;
  primaryColorCode: string;

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
    this.httpClient.get<any>(environment.apiUrl+"/api/configurations/header_footer_config?tenant="+this.hostKey).subscribe(
      (res) => {
        console.log(res)
        this.primaryColorCode = res.data.colors.primary_color
        this.tenant_logo_file = res.data.site_logo;
        this.tenant_url = res.data.marketplace_website_url;
      },
      (err) => {
        console.log(err)
      }
    );
  }

}