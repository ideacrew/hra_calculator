import { Component, OnInit } from '@angular/core';
import { HttpClient, HttpParams } from '@angular/common/http';
import { environment } from './../../../environments/environment';

@Component({
  selector: 'layout-footer',
  templateUrl: './footer.component.html',
  styleUrls: ['./../../app.component.scss']
})
export class FooterComponent implements OnInit{
	customer_support_number: String;
	benefit_year: number;
	today: number = Date.now();
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
        this.primaryColorCode = res.data.colors.primary_color;
        this.customer_support_number = res.data.call_center_phone;
        this.benefit_year = new Date().getFullYear() + 1;
      },
      (err) => {
        console.log(err)
      }
    );
  }
}