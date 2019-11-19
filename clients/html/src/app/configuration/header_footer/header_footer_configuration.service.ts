import { environment } from './../../../environments/environment';
import { HttpClient } from '@angular/common/http';
import { HeaderFooterConfigurationResource } from './header_footer_configuration.resources';
import { Injectable } from '@angular/core';
import { ResourceResponse } from '../../resources/hra_custom_api';
import { Observable, Subject, of, EMPTY, BehaviorSubject } from 'rxjs';
import { tap, map, catchError, take } from 'rxjs/operators';

@Injectable({ providedIn: 'root' })
export class HeaderFooterConfigurationService {
  headerFooterConfig: BehaviorSubject<
    HeaderFooterConfigurationResource
  > = new BehaviorSubject(undefined);

  headerFooterConfig$: Observable<
    HeaderFooterConfigurationResource
  > = this.headerFooterConfig.asObservable();

  headerApi$: Observable<HeaderFooterConfigurationResource>;

  private apiUrl: string;

  constructor(private httpClient: HttpClient) {
    const hostKey = environment.production
      ? window.location.host.split('.', 1)[0]
      : 'dc';

    this.apiUrl = `${environment.apiUrl}/api/configurations/header_footer_config?tenant=${hostKey}`;

    this.headerApi$ = this.httpClient
      .get<ResourceResponse<HeaderFooterConfigurationResource>>(this.apiUrl)
      .pipe(
        map(response => response.data),
        tap(configuration => this.headerFooterConfig.next(configuration)),
        catchError(e => {
          console.error({ e });
          return of(EMPTY); // we could return a "fallback" configuration object here
        })
      );
  }
}
