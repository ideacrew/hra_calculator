import { Component, OnInit } from '@angular/core';
import { FormGroup,  FormBuilder,  Validators } from '@angular/forms';
import { HttpClient } from '@angular/common/http';
import { environment } from './../../environments/environment';

@Component({
  templateUrl: './starter.component.html',
  styleUrls: ['./starter.component.scss']
})

export class StarterComponent implements OnInit {
  subtitle: string;
  currentTab: number = 0;
  showPrevBtn: boolean = false;
  showNextBtn: boolean =  true;
  hraForm: FormGroup;

  constructor(private fb: FormBuilder, private httpClient: HttpClient) {
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
    this.httpClient.post<any>(environment.apiUrl+"/hra_results/hra_payload", this.hraForm.value).subscribe(
      (res) => {
        console.log(res)
      },
      (err) => {
        console.log(err)
      }
    );
  }
}
