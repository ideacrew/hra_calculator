import { Component, OnInit, Input} from '@angular/core';
import { AbstractControl, FormGroup } from '@angular/forms';

@Component({
  selector: '[dropdown]',
  templateUrl: './dropdown.component.html',
  styleUrls: ['./dropdown.component.scss']
})
export class DropdownComponent {

  @Input("labelClass") labelClass : string = "col-sm-3 col-form-label col-form-label-sm";
  @Input("labelText") labelText : string = "";
  @Input("controlId") controlId : string = "";
  @Input("controlClass") controlClass : string = "col-sm-4";
  @Input("controlName") controlName : string | null = null;
  @Input("parentFormControl") parentFormControl : FormGroup | null = null;
  @Input("requiredErrorText") requiredErrorText : string | null = null;
  @Input("dangerColorCode") dangerColorCode : string | null = null;
  // @Input("span1Class") span1Class : string | null = null;
  @Input("dropdownOptions") dropdownOptions : string | null = null;
  @Input("control1Value") control1Value : string | null = null;
  @Input("control1Label") control1Label : string | null = null;
  @Input("span2Class") span2Class : string | null = null;
  @Input("control2Value") control2Value : string | null = null;
  @Input("control2Label") control2Label : string | null = null;
  @Input("popContent") popContent : string = "";

  formField: AbstractControl | null = null;

  ngOnInit() {
    if (this.controlName != null) {
      if (this.parentFormControl != null) {
        this.formField = this.parentFormControl.get(this.controlName);
      }
    }
  }
}