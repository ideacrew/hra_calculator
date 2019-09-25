import { Injectable } from '@angular/core';

@Injectable({
  providedIn: 'root',
})
export class ResultService {
  public setResults(results: any) {
    this._results = results;
  }

  public setFormData(data: any) {
    this._formData = data;
  }

  public get results(): any {
      return this._results;
  }

  public get formData(): any {
    return this._formData;
  }

  private _results: any = null; //or empty array if projects is an array}
  private _formData: any = null
}
