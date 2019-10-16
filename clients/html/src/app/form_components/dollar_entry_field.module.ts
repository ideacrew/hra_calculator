import { NgModule } from '@angular/core';
import { BrowserModule } from '@angular/platform-browser';
import { BrowserAnimationsModule } from '@angular/platform-browser/animations';
import { CommonModule} from '@angular/common';
import { FormsModule, ReactiveFormsModule } from '@angular/forms';
import { NgxMaskModule } from 'ngx-mask'

import { DollarEntryFieldComponent } from './dollar_entry_field.component';

@NgModule({
  declarations: [
    DollarEntryFieldComponent
  ],
  imports: [
    CommonModule,
    BrowserModule,
    BrowserAnimationsModule,
    FormsModule,
    ReactiveFormsModule,
    NgxMaskModule
  ],
  exports: [
    DollarEntryFieldComponent
  ]
})
export class DollarEntryFieldModule { }