interface TypedResource<A> {
  id?: string;
  type?: string;
  attributes: A;
  relationships?: any;
  meta?: MetaSet;
  links: any;
}

interface LinkObject {
  href: string;
  meta?: any;
}

interface LinkSet {
  first?: string | LinkObject;
  last?: string | LinkObject;
  prev?: string | LinkObject;
  next?: string | LinkObject;
  self?: string | LinkObject;
  related?: string | LinkObject;
}

interface MetaSet {
  [k: string] : any
}

interface JSONAPIHeader {
  version: string;
  meta?: MetaSet;
}

interface Response {
  jsonapi?: JSONAPIHeader;
  links?: LinkSet;
  meta?: MetaSet;
  status?: any;
}

export interface Resource<A> extends Response {
  data: TypedResource<A>;
  included?: any;
}

export interface ListResource<A> extends Response {
  data: Array<TypedResource<A>>;
  included?: any;
}

export interface ErrorResponse extends Response {
  errors: Array<any>;
}