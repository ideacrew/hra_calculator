import { JwtSessionToken } from './jwtSessionToken';

export class JwtUtility {
  static parse(header_string: string) {
    const raw_token = header_string.replace(/^Bearer /, '');
    const token_parts = raw_token.split('.');
    const body = token_parts[1];
    const user = JSON.parse(atob(body));
    user.token = raw_token;
    return user;
  }

  static get currentUser(): JwtSessionToken {
    const cu_string = localStorage.getItem('currentUser');
    return cu_string ? JSON.parse(cu_string) : null;
  }

  static store(user: JwtSessionToken) {
    localStorage.setItem('currentUser', JSON.stringify(user));
  }

  static remove() {
    localStorage.removeItem('currentUser');
  }

  static valid(user: JwtSessionToken): boolean {
    const now_time = Math.floor(Date.now() / 1000);
    return user.exp > now_time;
  }

  static inRefreshWindow(user: JwtSessionToken): boolean {
    const now_time = Math.floor(Date.now() / 1000);
    const liveLength = user.exp - user.iat;
    const refreshWindowStart = user.iat + liveLength / 2;
    if (user.exp <= now_time) {
      return false;
    }
    return refreshWindowStart < now_time;
  }
}
