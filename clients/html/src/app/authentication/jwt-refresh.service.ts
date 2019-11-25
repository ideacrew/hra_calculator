import { HttpClient, HttpHeaders, HttpResponse } from '@angular/common/http';
import { environment } from '../../environments/environment';
import { JwtUtility } from './jwt.utility';
import { Injectable } from '@angular/core';
import { tap } from 'rxjs/operators';
import { Observable } from 'rxjs';
import { JwtSessionToken } from './jwtSessionToken';

@Injectable({
  providedIn: 'root'
})
export class JwtService {
  static SKIP_INTERCEPTORS_HEADER = 'X-Skip-Angular-Interceptors';

  public user: any;

  constructor(private http: HttpClient) {}

  getToken() {
    this.issueToken.subscribe(response => {
      const auth_header = response.headers.get('Authorization');
      const user_record = JwtUtility.parse(auth_header);
      JwtUtility.store(user_record);
      // initialTokenListener.hasToken = true;
    });
  }

  get issueToken(): Observable<HttpResponse<any>> {
    const requestHeaders = new HttpHeaders({
      'Content-Type': 'text/plain'
    });
    const fullHeaders = requestHeaders.set(
      JwtService.SKIP_INTERCEPTORS_HEADER,
      'true'
    );

    return this.http.get(
      `${environment.apiUrl}/api/client_sessions/issue_token.html`,
      {
        headers: fullHeaders,
        observe: 'response',
        responseType: 'text'
      }
    );
  }

  get hasValidToken(): boolean {
    const user = JwtUtility.currentUser;
    if (!user) {
      return false;
    }
    return JwtUtility.valid(user);
  }
}
