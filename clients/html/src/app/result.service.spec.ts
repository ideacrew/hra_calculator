import { TestBed } from '@angular/core/testing';

import { ResultService } from './result.service';

describe('ResultService', () => {
  beforeEach(() => TestBed.configureTestingModule({
    providers: [ ResultService ]
  }));

  it('should be created', () => {
    const service: ResultService = TestBed.get(ResultService);
    expect(service).toBeTruthy();
  });

  it('should set and get the results value', () => {
    const service: ResultService = TestBed.get(ResultService);
    const stubValue = 'Test Results';

    service.setResults(stubValue);
    expect(service.results).toBe(stubValue);
  });
});
