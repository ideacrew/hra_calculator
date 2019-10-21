import { async, ComponentFixture, TestBed } from '@angular/core/testing';
import { ResultComponent } from './result.component';
import { ResultService }   from '../result.service';
import { Router } from '@angular/router';

describe('ResultComponent', () => {
  let component: ResultComponent;
  let fixture: ComponentFixture<ResultComponent>;
  let routerStub: Partial<Router>;
  let resultServiceStub: Partial<ResultService>;
  resultServiceStub = {
    results: {
      data: {
        colors: {
          primary_color: "red"
        },
        county: "",
        dob: "09/09/1990",
        // end_month: "2020-10-1",
        end_month: "10/01/2020",
        household_amount: "60000",
        household_frequency: "annually",
        hra_amount: "5000",
        hra_determination: "affordable",
        hra_frequency: "annually",
        hra_type: "ichra",
        marketPlace: "MARKETPLACE",
        // start_month: "2020-4-1",
        start_month: "04/01/2020",
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
      providers: [
        { provide: ResultService, useValue: resultServiceStub },
        { provide: Router, useValue: routerStub }
      ]
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

  it('should show the information the user entered', () => {
    let userInfo = "";
    fixture.nativeElement.querySelectorAll("div.content td").forEach((el) => {
      userInfo += el.textContent;
    });
    let results = resultServiceStub["results"]["data"]
    fixture.detectChanges();

    expect(userInfo).toContain(results["state"]);
    if (component.county != "") {
      expect(userInfo).toContain(results["county"]);
    }
    if (component.zipcode != "") {
      expect(userInfo).toContain(results["zipcode"]);
    }
    expect(userInfo).toContain(results["dob"]);
    expect(userInfo).toContain("60,000");
    // expect(userInfo).toContain(results["household_frequency"]);
    expect(userInfo).toContain("Annual");
    // expect(userInfo).toContain(results["hra_type"]);
    expect(userInfo).toContain("Individual Coverage HRA");
    // expect(userInfo).toContain(results["start_month"]);
    expect(userInfo).toContain("April 2020");
    // expect(userInfo).toContain(results["end_month"]);
    expect(userInfo).toContain("October 2020");
  });

  it('should show affordable ICHRA text', () => {
    let p = fixture.nativeElement.querySelector('#ichra-affordable');
    expect(p.textContent).toContain("is large enough");
  });

  it('should show unaffordable ICHRA text', () => {
    component.hra_determination = "unaffordable";
    fixture.detectChanges();
    let p = fixture.nativeElement.querySelector('#ichra-unaffordable');
    expect(p.textContent).toContain("is not large enough");
  });

  it('should show affordable QSEHRA text', () => {
    component.hra_type = "qsehra";
    fixture.detectChanges();
    let p = fixture.nativeElement.querySelector('#qsehra-affordable');
    expect(p.textContent).toContain("is large enough");
  });

  it('should show unaffordable QSEHRA text', () => {
    component.hra_determination = "unaffordable";
    component.hra_type = "qsehra";
    fixture.detectChanges();
    let p = fixture.nativeElement.querySelector('#qsehra-unaffordable');
    expect(p.textContent).toContain("is not large enough");
  });
});
