import { Component, OnInit, Input} from '@angular/core';
import { AbstractControl, FormGroup } from '@angular/forms';
import { ControlSettings } from '../configuration/control_settings'

@Component({
  selector: '[dropdown]',
  templateUrl: './dropdown.component.html',
  styleUrls: ['./dropdown.component.scss']
})

export class DropdownComponent {

  @Input("settings") settings : ControlSettings = {
    label: "Choose",
    description: "Select a Value From Dropdown"
  };

  @Input("labelClass") labelClass : string = "col-sm-3 col-form-label col-form-label-sm";
  @Input("labelText") labelText : string = "";
  @Input("controlId") controlId : string = "";
  @Input("controlClass") controlClass : string = "col-sm-4";
  @Input("controlName") controlName : string | null = null;
  @Input("parentFormControl") parentFormControl : FormGroup | null = null;
  @Input("requiredErrorText") requiredErrorText : string | null = null;
  @Input("dangerColorCode") dangerColorCode : string | null = null;
  @Input("placeHolderText") placeHolderText : string = "";
  @Input("dropdownOptions") dropdownOptions : any = [];
  @Input("formatDATE") formatDATE : boolean = false;
  @Input("displayToolTip") displayToolTip : boolean = false;
  @Input("popContent") popContent : string = "";
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