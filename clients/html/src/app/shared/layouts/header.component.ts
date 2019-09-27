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
  constructor(private httpClient: HttpClient,) { }

  ngOnInit() {
    this.getInitialInfo();
  }

  getInitialInfo() {
    this.httpClient.get<any>(environment.apiUrl+"/hra_results/header_footer_config").subscribe(
      (res) => {
        console.log(res)
        this.tenant_logo_file = res.data.tenant_logo_file;
        this.tenant_url = res.data.tenant_url;
      },
      (err) => {
        console.log(err)
      }
    );
  }

}