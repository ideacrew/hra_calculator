import { NgModule } from '@angular/core';
import { BrowserModule } from '@angular/platform-browser';
import { BrowserAnimationsModule } from '@angular/platform-browser/animations';
import { CommonModule} from '@angular/common';
import { HttpClientModule } from '@angular/common/http';
import { TokenizedTranslatePipe } from './tokenized_translate_pipe';
import { TokenizedHtmlTranslatePipe } from './tokenized_html_translate_pipe';

@NgModule({
  declarations: [
    TokenizedTranslatePipe,
    TokenizedHtmlTranslatePipe
  ],
  imports: [
    CommonModule,
    BrowserModule,
    BrowserAnimationsModule,
    HttpClientModule
  ],
  exports: [
    TokenizedTranslatePipe,
    TokenizedHtmlTranslatePipe
  ]
})
export class TokenizedTranslationModule { }