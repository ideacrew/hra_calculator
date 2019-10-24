import { HttpClient, HttpHeaders } from "@angular/common/http";
import { TranslateLoader} from "@ngx-translate/core";
import { Observable} from 'rxjs';
import { environment } from './../../environments/environment';
import { JwtRefreshService } from '../authentication/jwt_refresh_service';

export class TranslationHttpLoader implements TranslateLoader {
  private hostKey = "dc";

  constructor(private http: HttpClient) {
    if (environment.production) {
      this.hostKey = window.location.host.split(".",1)[0];
    }
  }

  /**
   * Gets the translations from the server
   */
  public getTranslation(lang: string): Observable<any> {
    var requestHeaders = new HttpHeaders({
      'Content-Type': 'text/plain'
    });
    var skipHeaders = requestHeaders.set(JwtRefreshService.SKIP_INTERCEPTORS_HEADER, "true");
    return this.http.get(environment.apiUrl + "/api/translations/" + lang + ".json?tenant=" + this.hostKey, { headers: skipHeaders });
  }
}