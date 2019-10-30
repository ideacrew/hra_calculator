import { Injectable } from '@angular/core';
import { HttpRequest, HttpHandler, HttpEvent, HttpInterceptor, HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs/Observable';
import { JwtUserService } from './jwt_user_service';
import { Router } from "@angular/router";
import { JwtRefreshService } from './jwt_refresh_service';
import { JwtSessionToken } from './jwt_session_token';
import 'rxjs/add/operator/catch';
import 'rxjs/add/observable/throw';
 
@Injectable()
export class JwtInterceptor implements HttpInterceptor {
    constructor(private router: Router, private http : HttpClient) {}

    intercept(request: HttpRequest<any>, next: HttpHandler): Observable<HttpEvent<any>> {
        if (request.headers.has(JwtRefreshService.SKIP_INTERCEPTORS_HEADER)) {
            return next.handle(request);
        }
        // add authorization header with jwt token if available
        let currentUser = JwtUserService.get<JwtSessionToken>();
        if (currentUser && JwtUserService.valid<JwtSessionToken>(currentUser)) {
            if (JwtUserService.inRefreshWindow(currentUser)) {
              var refresh_service = new JwtRefreshService(this.http);
              refresh_service.refresh(currentUser);
            }
            let newRequest = request.clone({
                setHeaders: { 
                    Authorization: `Bearer ${currentUser.token}`
                }
            });
            return next.handle(newRequest);
        } else {
            // Send me to the login page.
            console.log("HI");
        }
    }
}