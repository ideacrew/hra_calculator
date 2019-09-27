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

	constructor(private httpClient: HttpClient,) { }


  ngOnInit() {
    this.getInitialInfo();
  }

  getInitialInfo() {
    this.httpClient.get<any>(environment.apiUrl+"/hra_results/header_footer_config").subscribe(
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