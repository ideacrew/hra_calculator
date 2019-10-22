import { Maybe } from "../maybe"

export interface JwtUserBase {
  token: string
  exp: number
  iat: number
}

export class JwtUserService {
  static parse<T extends JwtUserBase>(header_string: string) : T {
    var raw_token = header_string.replace(/^Bearer /, "");
    var token_parts = raw_token.split(".");
    var body = token_parts[1];
    var user = <T>JSON.parse(atob(body));
    user.token = raw_token;
    return user;
  }

  static get<T extends JwtUserBase>() : Maybe<T>{
    var cu_string = localStorage.getItem("currentUser");
    return cu_string ? <T>JSON.parse(cu_string) : null;
  }

  static store<T extends JwtUserBase>(user : T) {
    localStorage.setItem("currentUser", JSON.stringify(user));
  }

  static remove() {
    localStorage.removeItem("currentUser");
  }

  static hasValidToken() : boolean {
    var user = JwtUserService.get();
    if (!user) {
      return false;
    }
    return JwtUserService.valid(user);
  }

  static valid<T extends JwtUserBase>(user: T) : boolean {
    var now_time = Math.floor(Date.now() / 1000);
    return(user.exp > now_time);
  }

  static inRefreshWindow<T extends JwtUserBase>(user: T) : boolean {
    var now_time = Math.floor(Date.now() / 1000);
    var liveLength = user.exp - user.iat;
    var refreshWindowStart = user.iat + (liveLength / 2);
    if (user.exp <= now_time) {
      return false;
    }
    return (refreshWindowStart < now_time);
  }
}