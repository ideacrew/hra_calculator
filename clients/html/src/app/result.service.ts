import { Injectable } from '@angular/core';

@Injectable({
  providedIn: 'root',
})
export class ResultService {
  public setResults(results: any) {
    this._results = results;
  }

  public get results(): any {
      return this._results;
  }

  private _results: any = null; //or empty array if projects is an array}
}
