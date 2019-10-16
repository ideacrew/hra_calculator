import { Component, Input } from '@angular/core';
import { AbstractControl, FormGroup } from '@angular/forms';

@Component({
  selector: '[dollarEntryField]',
  templateUrl: './dollar_entry_field.component.html',
  styleUrls: ['./dollar_entry_field.component.scss']
})
export class DollarEntryFieldComponent {
   @Input("labelClass") labelClass : String = "";
   @Input("labelText") labelText : String = "";
   @Input("controlId") controlId : String = "";
   @Input("controlClass") controlClass : String = "";
   @Input("formField") formField : AbstractControl | null = null;
   @Input("parentFormControl") parentFormControl : FormGroup | null = null;
   @Input("requiredErrorText") requiredErrorText : string = "Amount is required.";
   @Input("isDisabled") isDisabled : string | null = null;
}