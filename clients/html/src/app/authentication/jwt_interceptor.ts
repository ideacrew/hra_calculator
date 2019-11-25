import { Injectable } from '@angular/core';
import {
  HttpRequest,
  HttpHandler,
  HttpEvent,
  HttpInterceptor,
  HttpClient
} from '@angular/common/http';
import { Observable } from 'rxjs/Observable';
import { JwtUtility } from './jwt.utility';
import { JwtService } from './jwt-refresh.service';
import { JwtSessionToken } from './jwtSessionToken';

@Injectable()
export class JwtInterceptor implements HttpInterceptor {
  constructor(private http: HttpClient) {}

  intercept(
    request: HttpRequest<any>,
    next: HttpHandler
  ): Observable<HttpEvent<any>> {
    if (request.headers.has(JwtService.SKIP_INTERCEPTORS_HEADER)) {
      return next.handle(request);
    }
    // add authorization header with jwt token if available
    const currentUser = JwtUtility.currentUser;
    if (currentUser && JwtUtility.valid(currentUser)) {
      if (JwtUtility.inRefreshWindow(currentUser)) {
        const refresh_service = new JwtService(this.http);
        refresh_service.getToken;
      }
      const newRequest = request.clone({
        headers: request.headers.set(
          'Authorization',
          `Bearer ${currentUser.token}`
        )
      });

      return next.handle(newRequest);
    } else {
      // Send me to the login page.
      console.log('HI');
    }
  }
}
