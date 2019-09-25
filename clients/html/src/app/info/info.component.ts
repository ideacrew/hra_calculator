import { Component, OnInit } from '@angular/core';
import { FormGroup,  FormBuilder,  Validators } from '@angular/forms';
import { HttpClient, HttpParams } from '@angular/common/http';
import { environment } from './../../environments/environment';
import { Router } from '@angular/router';
import { ResultService } from '../result.service'
import { validateDate } from './date.validator'

@Component({
  templateUrl: './info.component.html',
  styleUrls: ['./info.component.scss']
})

export class InfoComponent implements OnInit {
  subtitle: string;
  currentTab: number = 0;
  showPrevBtn: boolean = false;
  showNextBtn: boolean =  true;
  hraForm: any;
  countyOptions: any = [];
  selectedHouseholdFrequency: string;
  selectedHraType: string;
  selectedHraFrequency: string;
  showZipcode: boolean = true;
  showCounty: boolean = true;
  showDob: boolean = true;
  today: any = new Date();

  constructor(
    private fb: FormBuilder,
    private httpClient: HttpClient,
    private router: Router,
    private resultService: ResultService
  ) {
    this.subtitle = 'This is some text within a card block.';
    this.createForm();
  }

  createForm() {
    this.hraForm = this.fb.group({
      state: ['', Validators.required ],
      zipcode: [''],
      county: [''],
      dob: ['', [Validators.required, validateDate]],
      household_frequency: ['', Validators.required ],
      household_amount: ['', Validators.required ],
      hra_type: ['', Validators.required ],
      start_month: ['', Validators.required ],
      end_month: ['', Validators.required ],
      hra_frequency: ['', Validators.required ],
      hra_amount: ['', Validators.required ],
    });
    console.log(this.hraForm);
  }

  ngOnInit() {
    this.showTab(0);
    this.getInitialInfo();
  }

  showTab(n) {
    // ... and fix the Previous/Next buttons:
    this.currentTab = n;
    if (n === 0) {
      this.showPrevBtn = false;
    } else {
      this.showPrevBtn = true;
    }
    if (n === 2) {
      this.showNextBtn = false;
    } else {
      this.showNextBtn = true;
    }
  }

  getInitialInfo() {
    this.httpClient.get<any>(environment.apiUrl+"/configurations/default_configuration").subscribe(
      (res) => {
        console.log(res)
         this.countyOptions = res.data.counties;
         this.getDisplayInfo(res);
         this.hraForm.patchValue({
          state: res.data.state_name
        });
      },
      (err) => {
        console.log(err)
      }
    );
  }

  getDisplayInfo(res) {
    this.showZipcode = res.data.display_zipcode;
    this.showCounty = res.data.display_county;
    // this.showDob = res.data.display_dob;
  }

  getCountyInfo() {
    let params = new HttpParams().set('hra_state', this.hraForm.value.state);
    params = params.append('hra_zipcode', this.hraForm.value.zipcode);
    this.httpClient.get<any>(environment.apiUrl+"/configurations/counties", {params: params}).subscribe(
      (res) => {
        console.log(res)
        this.countyOptions = res.data.counties
      },
      (err) => {
        console.log(err)
        this.countyOptions = []
      }
    );
  }

  onSubmit() {
    console.log(this.hraForm.value)
    if (this.hraForm.valid) {
      console.log(this.hraForm.value)
      this.httpClient.post<any>(environment.apiUrl+"/hra_results/hra_payload", this.hraForm.value).subscribe(
        (res) => {
          console.log(res)
          this.resultService.setResults(res);
          this.router.navigateByUrl('/result');
        },
        (err) => {
          console.log(err)
        }
      );
    }
  }

  onHouseholdChange(entry: string){
    console.log(entry)
    this.selectedHouseholdFrequency = entry;
  }

  onHraTypeChange(entry: string){
    this.selectedHraType = entry;
  }

  onHraFrequencyChange(entry: string){
    this.selectedHraFrequency = entry;
  }

  numberOnly(event): boolean {
    const charCode = (event.which) ? event.which : event.keyCode;
    if (charCode > 31 && (charCode < 48 || charCode > 57)) {
      return false;
    }
    return true;
  }
}