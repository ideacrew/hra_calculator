import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { InfoComponent } from './info.component';
import { DollarEntryFieldComponent } from './../form_components/dollar_entry_field.component';
import { RadioButtonFieldComponent } from './../form_components/radio_button_field.component';
import { TextEntryFieldComponent } from './../form_components/text_entry_field.component';
import { DropdownComponent } from './../form_components/dropdown.component';
import { HttpClient, HttpHandler } from '@angular/common/http';
import { FormsModule, ReactiveFormsModule } from '@angular/forms';
import { NgbModule } from '@ng-bootstrap/ng-bootstrap';
import { ResultService } from '../result.service'
import { Router } from '@angular/router';
import { By } from '@angular/platform-browser';

describe('InfoComponent', () => {
  let component: InfoComponent;
  let fixture: ComponentFixture<InfoComponent>;
  let resultServiceStub: any;
  let routerStub: any;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ InfoComponent, DollarEntryFieldComponent, RadioButtonFieldComponent, TextEntryFieldComponent, DropdownComponent ],
      providers: [
        { provide: ResultService, useValue: resultServiceStub },
        { provide: Router, useValue: routerStub },
        HttpClient,
        HttpHandler
      ],
      imports: [
        FormsModule,
        NgbModule,
        ReactiveFormsModule
      ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(InfoComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });

  it('should set effective end date options', () => {
    let dropdown = fixture.debugElement.query(By.css("#start_month")).nativeElement;
    dropdown.value = dropdown.options[1].value;
    component.setEffectiveEndOptions(dropdown.value);
    let startDate = new Date(dropdown.value);
    let nextDate = new Date(startDate.getFullYear(), startDate.getMonth() + 11, 1);
    dropdown.dispatchEvent(new Event('change'));
    fixture.detectChanges();
    expect(component.effectiveEndOptions.slice(-1)[0]).toEqual(nextDate);
  });

  it('should update household frequency onHouseholdChange', () => {
    fixture.nativeElement.querySelector("input#household_frequency[ng-reflect-value='monthly']").click();
    expect(component.selectedHouseholdFrequency).toBe("monthly");
    fixture.nativeElement.querySelector("input#household_frequency[ng-reflect-value='annually']").click();
    expect(component.selectedHouseholdFrequency).toBe("annually");
  });

  it('should update HRA type onHraTypeChange', () => {
    fixture.nativeElement.querySelector("input[ng-reflect-value='ichra']").click();
    expect(component.selectedHraType).toBe("ichra");
    fixture.nativeElement.querySelector("input[ng-reflect-value='qsehra']").click();
    expect(component.selectedHraType).toBe("qsehra");
  });

  it ('should update HRA frequency onHraFrequencyChange', () => {
    fixture.nativeElement.querySelector("input#hra_frequency[ng-reflect-value='monthly']").click();
    expect(component.selectedHraFrequency).toBe("monthly");
    fixture.nativeElement.querySelector("input#hra_frequency[ng-reflect-value='annually']").click();
    expect(component.selectedHraFrequency).toBe("annually");
  });
});
