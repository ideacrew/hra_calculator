import { environment } from './../../../environments/environment';
import { HttpClient } from '@angular/common/http';
import { HeaderFooterConfigurationResource } from "./header_footer_configuration.resources";
import { ClassProvider, Injectable } from '@angular/core';
import { ResourceResponse } from '../../resources/hra_custom_api';

export interface HeaderFooterConfigurationConsumer {
  applyHeaderFooterConfiguration(resource : HeaderFooterConfigurationResource) : void;
}

export interface HeaderFooterConfigurationProvider {
  getHeaderFooterConfiguration(consumer : HeaderFooterConfigurationConsumer) : any;
}

@Injectable()
export class HeaderFooterConfigurationService {
  private hostKey: string;
  private apiUrl: string;

  public configResource: HeaderFooterConfigurationResource | null = null;

  constructor(private httpClient: HttpClient) { 
    if (environment.production) {
      this.hostKey = window.location.host.split(".",1)[0];
    } else {
      this.hostKey = "dc";
    }
    this.apiUrl = environment.apiUrl + "/api/configurations/header_footer_config?tenant=" + this.hostKey;
  }

  getHeaderFooterConfiguration(consumer : HeaderFooterConfigurationConsumer) {
    if (this.configResource != null) {
      consumer.applyHeaderFooterConfiguration(this.configResource);
      return;
    }
    var service = this;
    this.httpClient.get<ResourceResponse<HeaderFooterConfigurationResource>>(this.apiUrl).subscribe(
      (res:ResourceResponse<HeaderFooterConfigurationResource>) => {
        service.configResource = res.data;
        consumer.applyHeaderFooterConfiguration(res.data);
      },
      (err) => {
        console.log("GOT ERROR");
        console.log(err);
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