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

    const css = `
    :root {
      --danger-color: ${danger_color};
      --info-color: ${info_color};
      --primary-color: ${primary_color};
      --secondary-color: ${secondary_color};
      --success-color: ${success_color};
      --warning-color: ${warning_color};
    }
    `;

    const head = document.head || document.getElementsByTagName('head')[0];
    const style = document.createElement('style');

    style.type = 'text/css';
    style.appendChild(document.createTextNode(css));

    head.appendChild(style);
  }

  // https://stackoverflow.com/questions/5623838/rgb-to-hex-and-hex-to-rgb
  hexToRgb(hex: string) {
    const [red, green, blue] = /^#?([a-f\d]{2})([a-f\d]{2})([a-f\d]{2})$/i.exec(
      hex
    );
    return [parseInt(red, 16), parseInt(green, 16), parseInt(blue, 16)];
  }

  getLuminance(rgbValue: number[]) {
    // Formula: http://www.w3.org/TR/2008/REC-WCAG20-20081211/#relativeluminancedef
    for (let value of rgbValue) {
      value /= 255;

      value =
        value < 0.03928
          ? value / 12.92
          : Math.pow((value + 0.055) / 1.055, 2.4);

      value[i] = value;
    }

    return 0.2126 * rgba[0] + 0.7152 * rgba[1] + 0.0722 * rgba[2];
  }
}
