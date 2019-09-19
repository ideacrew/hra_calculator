import { Component, OnInit } from '@angular/core';
import { ResultService } from '../result.service';

@Component({
  selector: 'app-result',
  templateUrl: './result.component.html',
  styleUrls: ['./result.component.css']
})
export class ResultComponent implements OnInit {
  result: any;
  state: String;
  zipcode: String;
  county: String;
  dob: Date;
  household_frequency: String;
  household_amount: Number;
  start_month: Date;
  end_month: Date;
  hra_frequency: String;
  hra_amount: Number;
  hra_type: String;
  hra_determination: String;

  showUnaffordableQsehraText: boolean = false;
  showAffordableQsehraText: boolean = false;
  showUnaffordableIchraText: boolean = false;
  showAffordableIchraText: boolean = false;
  constructor(private resultService: ResultService) {       
  }

  ngOnInit() {
    this.result = this.resultService.results;    
    this.state = this.result.data.state;
    this.zipcode = this.result.data.zipcode;
    this.county = this.result.data.county;
    this.dob = this.result.data.dob;
    this.household_frequency = this.result.data.household_frequency;
    this.household_amount = this.result.data.household_amount;
    this.start_month = this.result.data.start_month;
    this.end_month = this.result.data.end_month;
    this.hra_frequency = this.result.data.hra_frequency;
    this.hra_amount = this.result.data.hra_amount;
    this.hra_type = this.result.data.hra_type;
    this.hra_determination = this.result.data.hra_determination;
    if(this.hra_type == "qsehra") {
      if (this.hra_determination == 'unaffordable'){
        this.showUnaffordableQsehraText = true;
      } else if (this.hra_determination == 'affordable'){
        this.showAffordableQsehraText == true;
      }
    } else if(this.hra_type == "ichra"){
      if (this.hra_determination == 'unaffordable'){
        this.showUnaffordableIchraText = true;
      } else if (this.hra_determination == 'affordable') {
        this.showAffordableIchraText == true;
      }
    }
  }

}
