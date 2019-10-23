import { HttpClient} from "@angular/common/http";
import { TranslateLoader} from "@ngx-translate/core";
import { Observable} from 'rxjs';
import { environment } from './../../environments/environment';

export class TranslationHttpLoader implements TranslateLoader {
  private hostKey = "dc";

  constructor(private http: HttpClient) {}

  /**
   * Gets the translations from the server
   */
  public getTranslation(lang: string): Observable<Object> {
    return this.http.get(environment.apiUrl + "/api/translations/" + lang + ".json?tenant=" + this.hostKey);
  }
}