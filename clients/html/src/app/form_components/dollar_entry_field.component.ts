import { Component, Input } from '@angular/core';
import { AbstractControl, FormGroup } from '@angular/forms';

@Component({
  selector: '[dollarEntryField]',
  templateUrl: './dollar_entry_field.component.html',
  styleUrls: ['./dollar_entry_field.component.scss']
})
export class DollarEntryFieldComponent {
   @Input("labelClass") labelClass : string = "";
   @Input("labelText") labelText : string = "";
   @Input("controlId") controlId : string = "";
   @Input("controlClass") controlClass : string = "";
   @Input("formField") formField : AbstractControl | null = null;
   @Input("parentFormControl") parentFormControl : FormGroup | null = null;
   @Input("requiredErrorText") requiredErrorText : string = "Amount is required.";
   @Input("isDisabled") isDisabled : string | null = null;
}