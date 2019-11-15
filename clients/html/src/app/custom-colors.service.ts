import { Injectable } from '@angular/core';
import { CustomColors } from './models/defaultConfiguration';

@Injectable({
  providedIn: 'root'
})
export class CustomColorsService {
  constructor() {}

  registerCustomColors(customColors: CustomColors): void {
    const {
      danger_color,
      info_color,
      primary_color,
      secondary_color,
      success_color,
      warning_color
    } = customColors;

    const invertedTextColor =
      this.getContrastRatio(primary_color, '#f1f1f1') < 4.5
        ? '#010101'
        : '#f1f1f1';

    const css = `
    :root {
      --danger-color: ${danger_color};
      --info-color: ${info_color};
      --primary-color: ${primary_color};
      --secondary-color: ${secondary_color};
      --success-color: ${success_color};
      --warning-color: ${warning_color};
      --inverted-text-color: ${invertedTextColor};
    }
    `;

    const head = document.head || document.getElementsByTagName('head')[0];
    const style = document.createElement('style');

    style.type = 'text/css';
    style.appendChild(document.createTextNode(css));

    head.appendChild(style);
  }

  // https://stackoverflow.com/questions/5623838/rgb-to-hex-and-hex-to-rgb
  hexToRgb(hex: string): number[] {
    return hex
      .replace(
        /^#?([a-f\d])([a-f\d])([a-f\d])$/i,
        (m, r, g, b) => '#' + r + r + g + g + b + b
      )
      .substring(1)
      .match(/.{2}/g)
      .map(x => parseInt(x, 16));
  }

  // Formula: http://www.w3.org/TR/2008/REC-WCAG20-20081211/#relativeluminancedef
  getLuminance(rgbValues: number[]): number {
    const [red, green, blue] = rgbValues.map(val => {
      const srgb = val / 255;

      return srgb <= 0.03928
        ? srgb / 12.92
        : Math.pow((srgb + 0.055) / 1.055, 2.4);
    });

    return 0.2126 * red + 0.7152 * green + 0.0722 * blue;
  }

  // https://www.w3.org/TR/2008/REC-WCAG20-20081211/#contrast-ratiodef
  getContrastRatio(hex1: string, hex2: string): number {
    const rgb1 = this.hexToRgb(hex1);
    const rgb2 = this.hexToRgb(hex2);

    const luminance1 = this.getLuminance(rgb1) + 0.05;
    const luminance2 = this.getLuminance(rgb2) + 0.05;

    const contrastRatio =
      luminance1 > luminance2
        ? luminance1 / luminance2
        : luminance2 / luminance1;

    // Just grab last two decimals
    // https://github.com/LeaVerou/contrast-ratio/blob/gh-pages/color.js#L167
    return Math.floor(contrastRatio * 100) / 100;
  }
}
