import { ClassProvider } from "@angular/core";

export interface FontCustomizer {
  customizeFontFromTypefaceUrl(typefacesUrlValue: string | null, typeFaceName: string | null) : void;
}

export class FontCustomizerService {
  private FONT_FAMILY_ELEMENT_ID = "hra_calculator_custom_font_styles";
  private FONT_LINK_ELEMENT_ID = "hra_calculator_custom_font_css_link";

  customizeFontFromTypefaceUrl(typefacesUrlValue: string | null, typeFaceName: string | null) {
    if (typefacesUrlValue != null) {
      if (typeFaceName != null) {
        this.applyCustomFont(typeFaceName, typefacesUrlValue);
      }
    }
  }

  private applyCustomFont(fontFamily : string, fontUrl : string) {
    this.applyFontUrl(fontUrl);
    this.applyFontFamilyName(fontFamily);
  }

  private applyFontFamilyName(fontFamily) {
    var style_element = this.getCustomFontFamilyStyleElement();
    if (style_element != null) {
      style_element.innerHTML = `
        body {
          font-family: "${fontFamily}";
        }
        .popover {
          font-family: "${fontFamily}";
          font-style: italic;
        }
      `;
    }
  }

  private applyFontUrl(fontUrl) {
    var link_element = this.getCustomFontLinkStyleElement();
    if (link_element != null) {
      link_element.href = fontUrl;
    }
  }

  private getCustomFontFamilyStyleElement() {
    var style_element = document.getElementById(this.FONT_FAMILY_ELEMENT_ID);
    if (style_element != null) {
      return style_element;
    }
    var head_element = document.querySelector("head");
    var new_style_element = document.createElement("style");
    new_style_element.id = this.FONT_FAMILY_ELEMENT_ID;
    new_style_element.type = "text/css";
    head_element.appendChild(new_style_element);
    return new_style_element;
  }

  private getCustomFontLinkStyleElement() {
    var link_element = document.getElementById(this.FONT_LINK_ELEMENT_ID);
    if (link_element != null) {
      var cast_link_element = <HTMLLinkElement>link_element;
      if (cast_link_element != null) {
        return cast_link_element;
      }
    }
    var head_element = document.querySelector("head");
    var new_link_element = document.createElement("link");
    new_link_element.id = this.FONT_LINK_ELEMENT_ID;
    new_link_element.rel = "stylesheet";
    head_element.appendChild(new_link_element);
    return new_link_element;
  }

  static providers() : ClassProvider {
    return {
      provide: FontCustomizerService.PROVIDER_TOKEN,
      useClass: FontCustomizerService
    };
  }

  static PROVIDER_TOKEN = "DI_TOKEN_FOR_FontCustomizerService";
}