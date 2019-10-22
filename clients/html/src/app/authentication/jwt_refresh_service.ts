import { HttpClient, HttpHeaders, HttpResponse, HttpErrorResponse } from '@angular/common/http';
import { environment } from '../../environments/environment';

import { JwtSessionToken } from './jwt_session_token';
import { JwtUserService } from "./jwt_user_service";

interface InitialTokenListener {
  hasToken: boolean;
}

export class JwtRefreshService {
  static SKIP_INTERCEPTORS_HEADER = 'X-Skip-Angular-Interceptors';

  public user: any;
  
  constructor(private http: HttpClient) {
  }
  
  getFirstToken(initialTokenListener : InitialTokenListener) {
    var requestHeaders = new HttpHeaders({
      'Content-Type': 'text/plain'
    });
    var fullHeaders = requestHeaders.set(JwtRefreshService.SKIP_INTERCEPTORS_HEADER, "true");
    this.http.get(environment.apiUrl + '/api/client_sessions/issue_token.html', 
    {
      headers: fullHeaders,
      observe: 'response',
      responseType: 'text'
    })
    .subscribe(function(response) {
      var auth_header = <string>response.headers.get("Authorization");
      var user_record = JwtUserService.parse<JwtSessionToken>(auth_header);
      JwtUserService.store<JwtSessionToken>(user_record);
      initialTokenListener.hasToken = true;
    });
  }

  refresh(user: JwtSessionToken) {
    var requestHeaders = new HttpHeaders({
      'Content-Type': 'text/plain'
    });
    var fullHeaders = requestHeaders.set(JwtRefreshService.SKIP_INTERCEPTORS_HEADER, "true");
    this.http.get(environment.apiUrl + '/api/client_sessions/issue_token.html', {
      headers: fullHeaders,
      observe: 'response',
      responseType: 'text'
    })
    .subscribe(
      (response) => {
         var auth_header = <string>response.headers.get("Authorization");
         var user_record = JwtUserService.parse<JwtSessionToken>(auth_header);
          // set token property
          // store username and jwt token in local storage to keep user logged in between page refreshes
          JwtUserService.store<JwtSessionToken>(user_record);
        },
      (err:HttpErrorResponse) => {
        console.log(JSON.stringify(err));
      }
    )
  }
}