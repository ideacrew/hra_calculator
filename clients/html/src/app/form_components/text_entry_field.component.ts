import { Component, Input } from '@angular/core';
import { AbstractControl, FormGroup } from '@angular/forms';
import { ControlSettings } from '../configuration/control_settings'

@Component({
  selector: '[textEntryField]',
  templateUrl: './text_entry_field.component.html',
  styleUrls: ['./form.component.scss']
})
export class TextEntryFieldComponent {
  // Reactive form directives
  @Input("controlName") controlName : string | null = null;
  @Input("parentFormControl") parentFormControl : FormGroup | null = null;
  @Input("controlId") controlId : string | null = null;

  // Control Settings - customizable by admin UI
  @Input("settings") settings : ControlSettings = {
    label: "Text",
    description: "Enter a Text"
  };

  // Control Styling
  @Input("labelClass") labelClass : string = "col-sm-3 col-form-label col-form-label-sm";
  @Input("controlClass") controlClass : string = "col-sm-4";
  @Input("dangerColorCode") dangerColorCode : string | null = null;

  @Input("requiredErrorText") requiredErrorText : string = "Amount is required.";
  @Input("minlength") minLength : string | null = null;
  @Input("maxlength") maxLength : string | null = null;
  @Input("lengthErrorText") lengthErrorText : string | null = null;

  formField: AbstractControl | null = null;

  ngOnInit() {
    if (this.controlName != null) {
      if (this.parentFormControl != null) {
        this.formField = this.parentFormControl.get(this.controlName);
      }
    }
  }
} 