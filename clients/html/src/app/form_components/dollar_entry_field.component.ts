import { Component, Input } from '@angular/core';
import { AbstractControl, FormGroup } from '@angular/forms';

@Component({
  selector: '[dollarEntryField]',
  templateUrl: './dollar_entry_field.component.html',
  styleUrls: ['./dollar_entry_field.component.scss']
})
export class DollarEntryFieldComponent {
   @Input("labelClass") labelClass : string = "col-sm-3 col-form-label col-form-label-sm";
   @Input("labelText") labelText : string = "";
   @Input("controlId") controlId : string = "";
   @Input("controlClass") controlClass : string = "col-sm-4";
   @Input("formField") formField : AbstractControl | null = null;
   @Input("parentFormControl") parentFormControl : FormGroup | null = null;
   @Input("requiredErrorText") requiredErrorText : string = "Amount is required.";
   @Input("dangerColorCode") dangerColorCode : string | null = null;
   @Input("isDisabled") isDisabled : string | null = null;
}