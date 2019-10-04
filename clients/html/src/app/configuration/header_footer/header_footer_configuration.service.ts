import { environment } from './../../../environments/environment';
import { HttpClient } from '@angular/common/http';
import { HeaderFooterConfigurationResource } from "./header_footer_configuration.resources";
import { ClassProvider, Injectable } from '@angular/core';

interface HeaderFooterConfigurationConsumer {
  applyHeaderFooterConfiguration(resource : HeaderFooterConfigurationResource) : void;
}

export interface HeaderFooterConfigurationProvider {
  getHeaderFooterConfiguration(consumer : HeaderFooterConfigurationConsumer) : any;
}

@Injectable()
export class HeaderFooterConfigurationService {
  private hostKey: string;
  private apiUrl;

  constructor(private httpClient: HttpClient) { 
    if (environment.production) {
      this.hostKey = window.location.host.split(".",1)[0];
    } else {
      this.hostKey = "dc";
    }
    this.apiUrl = environment.apiUrl+"/api/configurations/header_footer_config?tenant="+this.hostKey;
  }

  getHeaderFooterConfiguration(consumer : HeaderFooterConfigurationConsumer) {
    this.httpClient.get<HeaderFooterConfigurationResource>(this.apiUrl).subscribe(
      (res) => {
        console.log(res)
        consumer.applyHeaderFooterConfiguration(res);
      },
      (err) => {
        console.log(err)
      }
    );
  }

  static providers() : ClassProvider {
    return {
      provide: HeaderFooterConfigurationService.PROVIDER_TOKEN,
      useClass: HeaderFooterConfigurationService
    };
  }

  static PROVIDER_TOKEN = "DI_TOKEN_FOR_HeaderFooterConfigurationProvider";
}