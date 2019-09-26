import { Component, OnInit } from '@angular/core';
import { FormGroup,  FormBuilder,  Validators, FormControl } from '@angular/forms';
import { HttpClient, HttpParams } from '@angular/common/http';
import { environment } from './../../environments/environment';
import { Router } from '@angular/router';
import { ResultService } from '../result.service'
import { validateDate } from './date.validator'
import { NgbDateStruct, NgbDatepickerConfig } from '@ng-bootstrap/ng-bootstrap';

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
  showZipcode: boolean = false;
  showCounty: boolean = false;
  showDob: boolean = true;
  today: any = new Date();
  effectiveStartOptions: any =[];
  effectiveEndOptions: any =[];
  currentDate = new Date(2019,12,1);
  showErrors: boolean = false;
  errors: any = [];

  constructor(
    private fb: FormBuilder,
    private httpClient: HttpClient,
    private router: Router,
    private resultService: ResultService,
    private config: NgbDatepickerConfig
  ) {

    for (var _i = 0; _i < 12; _i++) {
      let next_date = new Date(this.currentDate.getFullYear(), this.currentDate.getMonth()+_i, 1);
      this.effectiveStartOptions.push(next_date)
    }
    this.subtitle = 'This is some text within a card block.';
    this.createForm();
  }

  setEffectiveEndOptions(val) {
    this.effectiveEndOptions = []
    var date = new Date(Date.parse(val.split(" 00:00:00")[0]))
    for (var _i = 0; _i < 12; _i++) {
      var next_date = new Date(date.getFullYear(), date.getMonth()+_i, 1);
      this.effectiveEndOptions.push(next_date)
    }
  }

  createForm() {
    this.hraForm = this.fb.group({
      state: ['', Validators.required ],
      zipcode: ['', Validators.required],
      county: ['', Validators.required],
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
    this.httpClient.get<any>(environment.apiUrl+"/hra_results/hra_information").subscribe(
      (res) => {
        console.log(res)
         this.countyOptions = res.data.counties;
         this.getDisplayInfo(res);
         this.hraForm.patchValue({
          state: res.data.state_name
        });
        if(!this.showZipcode){
          this.hraForm.removeControl('zipcode');
        }
        if(!this.showCounty){
          this.hraForm.removeControl('county');
        }
        if(this.resultService.formData){
          this.hraForm.patchValue({
            state: this.resultService.formData.state,
            zipcode: this.resultService.formData.zipcode,
            county: this.resultService.formData.county,
            dob: this.resultService.formData.dob,
            household_frequency: this.resultService.formData.household_frequency,
            household_amount: this.resultService.formData.household_amount,
            hra_type: this.resultService.formData.hra_type,
            start_month: this.resultService.formData.start_month,
            end_month: this.resultService.formData.end_month,
            hra_frequency: this.resultService.formData.hra_frequency,
            hra_amount: this.resultService.formData.hra_amount,
          });
          this.effectiveEndOptions = [this.resultService.formData.end_month]
          this.selectedHouseholdFrequency = this.resultService.formData.household_frequency;
          this.selectedHraFrequency = this.resultService.formData.hra_frequency;
          this.selectedHraType = this.resultService.formData.hra_type;
        }
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
    this.httpClient.get<any>(environment.apiUrl+"/hra_results/hra_counties", {params: params}).subscribe(
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
      this.resultService.setFormData(this.hraForm.value);
      this.httpClient.post<any>(environment.apiUrl+"/hra_results/hra_payload", this.hraForm.value).subscribe(
        (res) => {
          console.log(res)
          if(res.status == 'success'){
            this.resultService.setResults(res);
            this.router.navigateByUrl('/result');
          }else{
            this.errors = res.errors;
            this.showErrors = true;
          }
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

  closeAlert() {
    this.showErrors = false;
    this.errors = []
  }
}