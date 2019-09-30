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
	benefit_year: String;
	today: number = Date.now();
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
    this.httpClient.get<any>(environment.apiUrl+"/api/configurations/header_footer_config?tenant="+this.hostKey).subscribe(
      (res) => {
        console.log(res)
        debugger
        this.customer_support_number = res.data.customer_support_number;
        this.benefit_year = res.data.benefit_year;
      },
      (err) => {
        console.log(err)
      }
    );
  }
}