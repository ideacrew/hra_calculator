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
}
