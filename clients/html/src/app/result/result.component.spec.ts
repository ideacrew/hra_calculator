import { async, ComponentFixture, TestBed, getTestBed } from '@angular/core/testing';
import { HttpClientModule } from '@angular/common/http';
import { BrowserModule } from '@angular/platform-browser';
import { CommonModule } from '@angular/common';
import { JwtRefreshService, InitialTokenListener } from '../authentication/jwt_refresh_service';
import { TokenizedTranslatePipe } from '../translations/tokenized_translate_pipe';
import { TokenizedHtmlTranslatePipe } from '../translations/tokenized_html_translate_pipe';
import { TranslateModule, TranslateLoader,  TranslateService } from '@ngx-translate/core';
import { HeaderFooterConfigurationService } from "../configuration/header_footer/header_footer_configuration.service";
import { Provider } from '@angular/core';
import { Observable } from 'rxjs/Observable';
import { of } from 'rxjs';
import { ResultComponent } from './result.component';
import { ResultService }   from '../result.service';
import { Router } from '@angular/router';

class MockTranslationLoader implements TranslateLoader {
  private mockTranslations = {
    "hra_results.determination_results.ichra_affordable": {
      "recommendation": "is large enough"
    },
    "hra_results.determination_results.ichra_unaffordable": {
      "recommendation": "is not large enough"
    },
    "hra_results.determination_results.qsehra_affordable": {
      "recommendation": "is large enough"
    },
    "hra_results.determination_results.qsehra_unaffordable": {
      "recommendation": "is not large enough"
    }
  };

  public getTranslation(lang: string): Observable<any> {
    return of(this.mockTranslations);
  }
}

export function createTranslateLoader() {
  return new MockTranslationLoader();
}

class MockHeaderFooterService {
  getHeaderFooterConfiguration(consumer : ResultComponent) {

  };
}

class MockJwtTokenRefresher {
  hasToken() {
    return true;
  }
  getFirstToken(initialTokenListener : InitialTokenListener) { }
};

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
      imports: [
        CommonModule,
        BrowserModule,
        HttpClientModule,
        TranslateModule.forRoot({
          loader: {
            provide: TranslateLoader,
            useClass: MockTranslationLoader
          }
        })
      ],
      providers: (<Array<Provider>>[
        {
          provide: JwtRefreshService.PROVIDER_TOKEN,
          useClass: MockJwtTokenRefresher
        },
        {
          provide: HeaderFooterConfigurationService.PROVIDER_TOKEN,
          useClass: MockHeaderFooterService
        },
        { 
          provide: ResultService,
          useValue: resultServiceStub
        },
        { 
          provide: Router,
          useValue: routerStub
        }
      ]),
      declarations: [ 
        ResultComponent,
        TokenizedHtmlTranslatePipe,
        TokenizedTranslatePipe
      ],
    })
    .compileComponents();
    getTestBed().get(TranslateService).use("en");
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
    fixture.nativeElement.querySelectorAll("div.content td").forEach((el: { textContent: string; }) => {
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
