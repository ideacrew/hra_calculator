import { async, ComponentFixture, TestBed } from '@angular/core/testing';
import { ResultComponent } from './result.component';
import { ResultService }   from '../result.service';

describe('ResultComponent', () => {
  let component: ResultComponent;
  let fixture: ComponentFixture<ResultComponent>;
  let resultServiceStub: Partial<ResultService>;
  resultServiceStub = {
    results: {
      data: {
        county: "",
        dob: "1990-09-09",
        end_month: "2020-10-1",
        household_amount: "60000",
        household_frequency: "annually",
        hra_amount: "5000",
        hra_frequency: "annually",
        hra_type: "ichra",
        marketPlace: "MARKETPLACE",
        start_month: "2020-4-1",
        state: "District of Columbia",
        taxCredit: "a tax credit",
        zipcode: ""
      },
      errors: [],
      status: "success"
    }
  };

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ ResultComponent ],
      providers: [ { provide: ResultService, useValue: resultServiceStub } ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(ResultComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeDefined();
  });

});
