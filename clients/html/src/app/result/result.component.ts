import { Component, OnInit } from '@angular/core';
import { ResultService } from '../result.service';
import { Router } from '@angular/router';

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
  taxCredit: String;
  marketPlace: String;
  help_text_1: String;
  help_text_2: String;
  short_term_plan_text: String;
  minimum_essential_coverage_text: String;
  minimum_essential_coverage_link: String;
  enroll_without_aptc_text: String;
  help_text_3: String;
  help_text_4: String;
  help_text_5: String;
  showUnaffordableQsehraText: boolean = false;
  showAffordableQsehraText: boolean = false;
  showUnaffordableIchraText: boolean = false;
  showAffordableIchraText: boolean = false;
  constructor(
    private resultService: ResultService,
    private router: Router,
  ) {
  }

  ngOnInit() {
    this.result = this.resultService.results;
    if(this.result){
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
      this.marketPlace = this.result.data.market_place;
      this.taxCredit = this.result.data.tax_credit;
      this.help_text_1 = this.result.data.help_text_1;
      this.help_text_2 = this.result.data.help_text_2;
      this.short_term_plan_text = this.result.data.short_term_plan;
      this.minimum_essential_coverage_text = this.result.data.minimum_essential_coverage;
      this.minimum_essential_coverage_link = this.result.data.minimum_essential_coverage_link;
      this.enroll_without_aptc_text = this.result.data.enroll_without_aptc;
      this.help_text_3 = this.result.data.help_text_3;
      this.help_text_4 = this.result.data.help_text_4;
      this.help_text_5 = this.result.data.help_text_5;
      this.hra_type = this.result.data.hra_type;
      this.hra_determination = this.result.data.hra_determination;
    }else{
      this.router.navigateByUrl('/home');
    }
    if(this.hra_type == "qsehra") {
      if (this.hra_determination == 'unaffordable'){
        this.showUnaffordableQsehraText = true;
      } else if (this.hra_determination == 'affordable'){
        this.showAffordableQsehraText = true;
      }
    } else if(this.hra_type == "ichra"){
      if (this.hra_determination == 'unaffordable'){
        this.showUnaffordableIchraText = true;
      } else if (this.hra_determination == 'affordable') {
        this.showAffordableIchraText = true;
      }
    }
  }

}
