import { async, ComponentFixture, TestBed, getTestBed } from '@angular/core/testing';
import { HttpClientModule } from '@angular/common/http';
import { BrowserModule } from '@angular/platform-browser';
import { CommonModule } from '@angular/common';
import { HomeComponent } from './home.component';
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
  getHeaderFooterConfiguration(consumer : HomeComponent) {

  };
}

class MockJwtTokenRefresher {
  hasToken() {
    return true;
  }
  getFirstToken(initialTokenListener : InitialTokenListener) { }
};

describe('HomeComponent', () => {
  let component: HomeComponent;
  let fixture: ComponentFixture<HomeComponent>;

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
        }
      ]),
      declarations: [ 
        HomeComponent,
        TokenizedHtmlTranslatePipe,
        TokenizedTranslatePipe
      ]
    })
    .compileComponents();
    getTestBed().get(TranslateService).use("en");
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(HomeComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeDefined();
  });

  it('should display given taxCredit and marketplace values', () => {
    let p = fixture.nativeElement.querySelector("p[class='center-italic']");
    fixture.detectChanges();
    expect(p.textContent).toContain('Test Tax Credit');
  });
});
