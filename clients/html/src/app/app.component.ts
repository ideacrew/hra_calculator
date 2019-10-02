import { Component } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { HttpErrorResponse } from '@angular/common/http';
import {NgxMaskModule} from 'ngx-mask'
import { NgbDatepickerConfig, NgbDateParserFormatter } from '@ng-bootstrap/ng-bootstrap';
import { NgbDateStandardParserFormatter } from "./ngb-date-standard-parser-formatter"

@Component({
  providers: [{provide: NgbDateParserFormatter, useClass: NgbDateStandardParserFormatter}],
  selector: 'app-root',
  templateUrl: './app.component.html',
  styleUrls: ['./app.component.css']
})
export class AppComponent {
  title = 'app';
}
