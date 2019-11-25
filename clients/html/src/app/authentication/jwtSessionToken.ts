export interface JwtSessionToken {
  token: string;
  exp: number;
  iat?: number;
  hsa_session_id?: number;
}
