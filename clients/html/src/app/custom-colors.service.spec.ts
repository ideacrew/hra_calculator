import { TestBed } from '@angular/core/testing';
import { CustomColorsService } from './custom-colors.service';

describe('CustomColorsService', () => {
  let service: CustomColorsService;

  beforeEach(() => {
    TestBed.configureTestingModule({});
    service = TestBed.get(CustomColorsService);
  });

  it('should be created', () => {
    expect(service).toBeTruthy();
  });

  describe('hexToRgb', () => {
    it('should return [255,255,255] for #ffffff', () => {
      expect(service.hexToRgb('#ffffff')).toEqual([255, 255, 255]);
    });

    it('should return [0,0,0] for #000000', () => {
      expect(service.hexToRgb('#000000')).toEqual([0, 0, 0]);
    });
  });

  describe('getLuminance', () => {
    it('should return 1 for [255,255,255]', () => {
      expect(service.getLuminance([255, 255, 255])).toEqual(1);
    });

    it('should return 0 for [0,0,0]', () => {
      expect(service.getLuminance([0, 0, 0])).toEqual(0);
    });
  });

  describe('contrastRatio', () => {
    it('should return 21 for (#ffffff, #000000)', () => {
      expect(service.getContrastRatio('#ffffff', '#000000')).toEqual(21);
    });
    it('should return 1 for (#e1e1e1, #e1e1e1)', () => {
      expect(service.getContrastRatio('#e1e1e1', '#e1e1e1')).toEqual(1);
    });
    it('should return 7.64 for (#efe354, #484213)', () => {
      expect(service.getContrastRatio('#efe354', '#484213')).toEqual(7.64);
    });
  });
});
