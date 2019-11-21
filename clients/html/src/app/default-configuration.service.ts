import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { environment } from 'src/environments/environment';
import { CustomColorsService } from './custom-colors.service';
import { Observable, BehaviorSubject } from 'rxjs';
import { tap } from 'rxjs/operators';

@Injectable({
  providedIn: 'root'
})
export class DefaultConfigurationService {
  configuration = new BehaviorSubject({});
  configuration$ = this.configuration.asObservable();

  defaultConfigApi$: Observable<any>;

  constructor(
    private http: HttpClient,
    private colorService: CustomColorsService
  ) {
    const hostKey = environment.production
      ? window.location.host.split('.', 1)[0]
      : 'dc';

    this.defaultConfigApi$ = this.http
      .get<any>(
        `${environment.apiUrl}/api/configurations/default_configuration?tenant=${hostKey}`
      )
      .pipe(
        tap(res => this.configuration.next(res)),
        tap(res => this.colorService.registerCustomColors(res.data.colors))
      );
  }
}
