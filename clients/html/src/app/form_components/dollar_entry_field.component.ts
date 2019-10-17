import { Component, Input } from '@angular/core';
import { AbstractControl, FormGroup } from '@angular/forms';
import { ControlSettings } from '../configuration/control_settings'

@Component({
  selector: '[dollarEntryField]',
  templateUrl: './dollar_entry_field.component.html',
  styleUrls: ['./dollar_entry_field.component.scss']
})
export class DollarEntryFieldComponent {
  // Reactive form directives
  @Input("controlName") controlName : string | null = null;
  @Input("parentFormControl") parentFormControl : FormGroup | null = null;

  // Control Settings - customizable by admin UI
  @Input("settings") settings : ControlSettings = {
    label: "Dollars",
    description: "Enter a Dollar Amount"
  };

  // Control Styling
  @Input("labelClass") labelClass : string = "col-sm-3 col-form-label col-form-label-sm";
  @Input("controlClass") controlClass : string = "col-sm-4";
  @Input("dangerColorCode") dangerColorCode : string | null = null;

  @Input("requiredErrorText") requiredErrorText : string = "Amount is required.";
  @Input("isDisabled") isDisabled : string | null = null;

  formField: AbstractControl | null = null;

  ngOnInit() {
    if (this.controlName != null) {
      if (this.parentFormControl != null) {
        this.formField = this.parentFormControl.get(this.controlName);
      }
    }
  }
}