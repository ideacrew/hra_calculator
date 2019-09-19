import { Component, OnInit } from '@angular/core';
import { FormGroup,  FormBuilder,  Validators } from '@angular/forms';
import { HttpClient } from '@angular/common/http';
import { environment } from './../../environments/environment';
import { Router } from '@angular/router';
import { ResultService } from '../result.service'

@Component({
  templateUrl: './info.component.html',
  styleUrls: ['./info.component.scss']
})

export class InfoComponent implements OnInit {
  subtitle: string;
  currentTab: number = 0;
  showPrevBtn: boolean = false;
  showNextBtn: boolean =  true;
  hraForm: FormGroup;
  selectedHouseholdFrequency: string;
  selectedHraType: string;
  selectedHraFrequency: string;

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
      zipcode: ['', Validators.required ],
      county: ['', Validators.required ],
      dob: ['', Validators.required ],
      household_frequency: ['', Validators.required ],
      household_amount: ['', Validators.required ],
      hra_type: ['', Validators.required ],
      start_month: ['', Validators.required ],
      end_month: ['', Validators.required ],
      hra_frequency: ['', Validators.required ],
      hra_amount: ['', Validators.required ],
    });
  }

  ngOnInit() {
    this.showTab(0);
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

  onSubmit() {
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
}