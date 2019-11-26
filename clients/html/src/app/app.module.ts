import { BrowserModule } from '@angular/platform-browser';
import { BrowserAnimationsModule } from '@angular/platform-browser/animations';
import { CommonModule } from '@angular/common';
import { HashLocationStrategy, LocationStrategy } from '@angular/common';
import { NgModule } from '@angular/core';
import { FormsModule, ReactiveFormsModule } from '@angular/forms';
import { HttpClient } from '@angular/common/http';
import { HttpClientModule, HTTP_INTERCEPTORS } from '@angular/common/http';
import { RouterModule } from '@angular/router';

import { NgbModule } from '@ng-bootstrap/ng-bootstrap';
import { NgxMaskModule } from 'ngx-mask';

import { routes } from './app-routing.module';
import { AppComponent } from './app.component';

import { HomeComponent } from './home/home.component';
import { InfoComponent } from './info/info.component';
import { ResultComponent } from './result/result.component';
import { TranslationHttpLoader } from './translations/translation_loader';
import { TranslateModule, TranslateLoader } from '@ngx-translate/core';
import { TokenizedTranslationModule } from './translations/tokenized_translation_module';

import { JwtInterceptor } from './authentication/jwt_interceptor';
import { LayoutsModule } from './shared/layouts/layouts.module';

export function createTranslateLoader(http: HttpClient) {
  return new TranslationHttpLoader(http);
}

@NgModule({
  declarations: [AppComponent, HomeComponent, InfoComponent, ResultComponent],
  imports: [
    CommonModule,
    BrowserModule,
    BrowserAnimationsModule,
    FormsModule,
    ReactiveFormsModule,
    HttpClientModule,
    NgbModule,
    LayoutsModule,
    RouterModule.forRoot(routes, { useHash: true }),
    NgxMaskModule.forRoot(),
    TranslateModule.forRoot({
      loader: {
        provide: TranslateLoader,
        useFactory: createTranslateLoader,
        deps: [HttpClient]
      }
    }),
    TokenizedTranslationModule
  ],
  providers: [
    {
      provide: LocationStrategy,
      useClass: HashLocationStrategy
    },
    {
      provide: HTTP_INTERCEPTORS,
      useClass: JwtInterceptor,
      multi: true
    }
  ],
  bootstrap: [AppComponent]
})
export class AppModule {}
