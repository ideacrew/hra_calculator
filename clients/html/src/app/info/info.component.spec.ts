import { async, ComponentFixture, TestBed, getTestBed} from '@angular/core/testing';
import { HttpClientModule } from '@angular/common/http';
import { BrowserModule } from '@angular/platform-browser';
import { CommonModule } from '@angular/common';
import { InfoComponent } from './info.component';
import { HttpClient, HttpHandler } from '@angular/common/http';
import { FormsModule, ReactiveFormsModule } from '@angular/forms';
import { NgbModule } from '@ng-bootstrap/ng-bootstrap';
import { ResultService } from '../result.service'
import { Router } from '@angular/router';
import { By } from '@angular/platform-browser';
import { JwtRefreshService, InitialTokenListener } from '../authentication/jwt_refresh_service';
import { TokenizedTranslatePipe } from '../translations/tokenized_translate_pipe';
import { TokenizedHtmlTranslatePipe } from '../translations/tokenized_html_translate_pipe';
import { TranslateModule, TranslateLoader,  TranslateService } from '@ngx-translate/core';
import { HeaderFooterConfigurationService } from "../configuration/header_footer/header_footer_configuration.service";
import { Provider } from '@angular/core';
import { Observable } from 'rxjs/Observable';
import { of } from 'rxjs';

class MockTranslationLoader implements TranslateLoader {
  private mockTranslations = {
    "getting_started": {
      "disclaimer": "Test Tax Credit"
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
  getHeaderFooterConfiguration(consumer : InfoComponent) {

  };
}

class MockJwtTokenRefresher {
  hasToken() {
    return true;
  }
  getFirstToken(initialTokenListener : InitialTokenListener) { }
};

describe('InfoComponent', () => {
  let component: InfoComponent;
  let fixture: ComponentFixture<InfoComponent>;
  let resultServiceStub: any;
  let routerStub: any;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      imports: [
        CommonModule,
        BrowserModule,
        HttpClientModule,
        FormsModule,
        NgbModule,
        ReactiveFormsModule,
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
        },
        HttpClient,
        HttpHandler
      ]),
      declarations: [ 
        InfoComponent,
        TokenizedHtmlTranslatePipe,
        TokenizedTranslatePipe
      ]
    })
    .compileComponents();
    getTestBed().get(TranslateService).use("en");
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
    let startDate = new Date(dropdown.value);
    let nextDate = new Date(startDate.getFullYear(), startDate.getMonth() + 11, 1);
    dropdown.dispatchEvent(new Event('change'));
    fixture.detectChanges();
    expect(component.effectiveEndOptions.slice(-1)[0]).toEqual(nextDate);
  });

  it('should update household frequency onHouseholdChange', () => {
    fixture.nativeElement.querySelector("input#household_frequency[value='monthly']").click();
    expect(component.selectedHouseholdFrequency).toBe("monthly");
    fixture.nativeElement.querySelector("input#household_frequency[value='annually']").click();
    expect(component.selectedHouseholdFrequency).toBe("annually");
  });

  it('should update HRA type onHraTypeChange', () => {
    fixture.nativeElement.querySelector("input[value='ichra']").click();
    expect(component.selectedHraType).toBe("ichra");
    fixture.nativeElement.querySelector("input[value='qsehra']").click();
    expect(component.selectedHraType).toBe("qsehra");
  });

  it ('should update HRA frequency onHraFrequencyChange', () => {
    fixture.nativeElement.querySelector("input#hra_frequency[value='monthly']").click();
    expect(component.selectedHraFrequency).toBe("monthly");
    fixture.nativeElement.querySelector("input#hra_frequency[value='annually']").click();
    expect(component.selectedHraFrequency).toBe("annually");
  });
});
