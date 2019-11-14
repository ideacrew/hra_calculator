import { Component, OnInit, Inject } from '@angular/core';
import {
  FormGroup,
  FormBuilder,
  Validators,
  FormControl
} from '@angular/forms';
import { HttpClient, HttpParams } from '@angular/common/http';
import { environment } from './../../environments/environment';
import { Router } from '@angular/router';
import { ResultService } from '../result.service';
import { validateDate, validateDateFormat } from './date.validator';
import {
  NgbDateStruct,
  NgbDatepickerConfig,
  NgbCalendar
} from '@ng-bootstrap/ng-bootstrap';
import { NgxMaskModule } from 'ngx-mask';
import {
  JwtRefreshService,
  JwtTokenRefresher
} from '../authentication/jwt_refresh_service';

@Component({
  templateUrl: './info.component.html',
  styleUrls: ['./info.component.scss']
})
export class InfoComponent implements OnInit {
  subtitle: string;
  currentTab: number = 0;
  showPrevBtn: boolean = false;
  showNextBtn: boolean = true;
  hraForm: any;
  countyOptions: any = [];
  countyPlaceHolder: string = 'Choose';
  selectedHouseholdFrequency: string;
  selectedHraType: string;
  selectedHraFrequency: string;
  showZipcode: boolean = false;
  showCounty: boolean = false;
  showDob: boolean = true;
  today: any;
  effectiveStartOptions: any = [];
  effectiveEndOptions: any = [];
  currentDate = new Date(2019, 12, 1);
  showErrors: boolean = false;
  errors: any = [];
  isCountyDisabled: boolean = false;
  hostKey: string;
  private _hasToken: boolean = false;

  public get hasToken(): boolean {
    return this._hasToken;
  }

  public set hasToken(val) {
    this._hasToken = val;
    if (this._hasToken) {
      this.getInitialInfo();
    }
  }

  constructor(
    @Inject(JwtRefreshService.PROVIDER_TOKEN)
    private jwtTokenRefresher: JwtTokenRefresher,
    private fb: FormBuilder,
    private httpClient: HttpClient,
    private router: Router,
    private resultService: ResultService,
    private config: NgbDatepickerConfig
  ) {
    for (var _i = 0; _i < 12; _i++) {
      let next_date = new Date(
        this.currentDate.getFullYear(),
        this.currentDate.getMonth() + _i,
        1
      );
      this.effectiveStartOptions.push(next_date);
    }
    this.subtitle = 'This is some text within a card block.';
    this.createForm();

    if (environment.production) {
      this.hostKey = window.location.host.split('.', 1)[0];
    } else {
      this.hostKey = 'dc';
    }
  }

  setEffectiveEndOptions(val) {
    this.effectiveEndOptions = [];
    var date = new Date(Date.parse(val.split(' 00:00:00')[0]));
    for (var _i = 0; _i < 12; _i++) {
      var next_date = new Date(date.getFullYear(), date.getMonth() + _i, 1);
      this.effectiveEndOptions.push(next_date);
    }
  }

  createForm() {
    this.hraForm = this.fb.group({
      state: ['', Validators.required],
      zipcode: ['', Validators.required],
      county: ['', Validators.required],
      dob: ['', [Validators.required, validateDate, validateDateFormat]],
      household_frequency: ['', Validators.required],
      household_amount: ['', Validators.required],
      hra_type: ['', Validators.required],
      start_month: ['', Validators.required],
      end_month: ['', Validators.required],
      hra_frequency: ['', Validators.required],
      hra_amount: ['', Validators.required]
    });
    console.log(this.hraForm);
  }

  checkValue(str, max) {
    if (str.charAt(0) !== '0' || str == '00') {
      var num = parseInt(str);
      if (isNaN(num) || num <= 0 || num > max) num = 1;
      str =
        num > parseInt(max.toString().charAt(0)) && num.toString().length == 1
          ? '0' + num
          : num.toString();
    }
    return str;
  }

  checkDateInput(e) {
    var input = e.target.value;
    if (/\D\/$/.test(input)) input = input.substr(0, input.length - 3);
    var values = input.split('/').map(function(v) {
      return v.replace(/\D/g, '');
    });
    if (values[0]) values[0] = this.checkValue(values[0], 12);
    if (values[1]) values[1] = this.checkValue(values[1], 31);
    var output = values.map(function(v, i) {
      return v.length == 2 && i < 2 ? v + ' / ' : v;
    });
    e.target.value = output.join('').substr(0, 14);
  }

  ngOnInit() {
    const today = new Date();
    this.today = {
      year: today.getFullYear(),
      month: today.getMonth() + 1,
      day: today.getDate()
    };
    this.hasToken = this.jwtTokenRefresher.hasToken();
    if (!this.hasToken) {
      this.jwtTokenRefresher.getFirstToken(this);
    }
    this.showTab(0);
  }

  showTab(n) {
    if (n === 1) {
      let invalid = false;
      if (
        this.hraForm.controls['zipcode'] &&
        !this.hraForm.controls['zipcode'].valid
      ) {
        this.hraForm.controls['zipcode'].markAsTouched();
        invalid = true;
      }
      if (
        this.hraForm.controls['county'] &&
        !this.hraForm.controls['county'].valid
      ) {
        this.hraForm.controls['county'].markAsTouched();
        invalid = true;
      }
      if (this.hraForm.controls['dob'] && !this.hraForm.controls['dob'].valid) {
        this.hraForm.controls['dob'].markAsTouched();
        invalid = true;
      }
      if (
        !this.hraForm.controls['household_frequency'].valid ||
        !this.hraForm.controls['household_amount'].valid
      ) {
        this.hraForm.controls['household_frequency'].markAsTouched();
        this.hraForm.controls['household_amount'].markAsTouched();
        invalid = true;
      }
      if (invalid) {
        return null;
      }
    }
    window.scroll(0, 0);

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
    this.httpClient
      .get<any>(
        environment.apiUrl +
          '/api/configurations/default_configuration?tenant=' +
          this.hostKey
      )
      .subscribe(
        res => {
          console.log(res);
          this.countyOptions = res.data.counties;
          this.getDisplayInfo(res);
          this.hraForm.patchValue({
            state: res.data.state_name
          });
          if (!this.showZipcode) {
            this.hraForm.removeControl('zipcode');
          }
          if (!this.showCounty) {
            this.hraForm.removeControl('county');
          }
          if (!this.showDob) {
            this.hraForm.removeControl('dob');
          }
          if (this.resultService.formData) {
            if (this.showDob) {
              var date_string = this.resultService.formData.dob.split('-');
              this.hraForm.patchValue({
                dob: {
                  year: +date_string[0],
                  month: +date_string[1],
                  day: +date_string[2]
                }
              });
            }
            this.hraForm.patchValue({
              state: this.resultService.formData.state,
              zipcode: this.resultService.formData.zipcode,
              county: this.resultService.formData.county,
              household_frequency: this.resultService.formData
                .household_frequency,
              household_amount: this.resultService.formData.household_amount,
              hra_type: this.resultService.formData.hra_type,
              start_month: this.resultService.formData.start_month,
              end_month: this.resultService.formData.end_month,
              hra_frequency: this.resultService.formData.hra_frequency,
              hra_amount: this.resultService.formData.hra_amount
            });

            if (this.showZipcode) {
              this.countyOptions = [this.resultService.formData.county];
            }

            this.setEffectiveEndOptions(
              this.resultService.formData.start_month
            );
            this.selectedHouseholdFrequency = this.resultService.formData.household_frequency;
            this.selectedHraFrequency = this.resultService.formData.hra_frequency;
            this.selectedHraType = this.resultService.formData.hra_type;
          }
        },
        err => {
          console.log(err);
        }
      );
  }

  getDisplayInfo(res) {
    if (res.data.features.rating_area_model === 'zipcode') {
      this.showZipcode = true;
      this.showCounty = true;
    } else if (res.data.features.rating_area_model === 'county') {
      this.showZipcode = false;
      this.showCounty = true;
    } else if (res.data.features.rating_area_model === 'single') {
      this.showZipcode = false;
      this.showCounty = false;
    }
    this.showDob = res.data.features.use_age_ratings === 'age_rated';
  }

  getCountyInfo() {
    if (this.hraForm.value.zipcode.length == 5) {
      let params = new HttpParams().set('hra_state', this.hraForm.value.state);
      params = params.append('hra_zipcode', this.hraForm.value.zipcode);
      this.httpClient
        .get<any>(
          environment.apiUrl +
            '/api/configurations/counties?tenant=' +
            this.hostKey,
          { params: params }
        )
        .subscribe(
          res => {
            console.log(res);
            if (res.data.counties.length == 0) {
              this.countyOptions = [];
              this.countyPlaceHolder = 'zipcode is outside state';
              this.hraForm.patchValue({
                county: ''
              });
              this.isCountyDisabled = true;
            } else if (res.data.counties.length == 1) {
              this.countyOptions = res.data.counties;
              this.countyPlaceHolder = 'Choose';
              this.hraForm.patchValue({
                county: res.data.counties[0]
              });
              this.isCountyDisabled = true;
            } else {
              this.countyOptions = res.data.counties;
              this.countyPlaceHolder = 'Choose';
              this.hraForm.patchValue({
                county: ''
              });
              this.isCountyDisabled = false;
            }
          },
          err => {
            console.log(err);
            this.countyOptions = [];
          }
        );
    } else {
      this.countyPlaceHolder = 'Choose';
      this.hraForm.patchValue({
        county: ''
      });
      this.isCountyDisabled = true;
    }
  }

  onSubmit() {
    if (this.hraForm.valid) {
      var params = this.hraForm.value;
      this.today;
      if (this.showDob) {
        params.dob = `${params.dob.year}-${params.dob.month}-${params.dob.day}`;
      }
      this.resultService.setFormData(params);
      this.httpClient
        .post<any>(
          environment.apiUrl +
            '/api/hra_results/hra_payload?tenant=' +
            this.hostKey,
          this.hraForm.value
        )
        .subscribe(
          res => {
            if (res.status == 'success') {
              this.resultService.setResults(res);
              this.router.navigateByUrl('/result');
            } else {
              this.errors = res.errors;
              this.showErrors = true;
              window.scroll(0, 0);
            }
          },
          err => {
            console.log(err);
          }
        );
    } else {
      this.hraForm.markAllAsTouched();
      window.scroll(0, 0);
    }
  }

  onHouseholdChange(entry: string) {
    console.log(entry);
    this.selectedHouseholdFrequency = entry;
  }

  onHraTypeChange(entry: string) {
    this.selectedHraType = entry;
  }

  onHraFrequencyChange(entry: string) {
    this.selectedHraFrequency = entry;
  }

  numberOnly(event): boolean {
    const charCode = event.which ? event.which : event.keyCode;
    if (charCode > 31 && (charCode < 48 || charCode > 57)) {
      return false;
    }
    return true;
  }

  closeAlert() {
    this.showErrors = false;
    this.errors = [];
  }
}
