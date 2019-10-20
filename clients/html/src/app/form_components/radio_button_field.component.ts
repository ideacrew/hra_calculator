import { Component, Input, Output, EventEmitter } from '@angular/core';
import { AbstractControl, FormGroup } from '@angular/forms';
import { ControlSettings } from '../configuration/control_settings'

@Component({
  selector: '[radioButtonField]',
  templateUrl: './radio_button_field.component.html',
  styleUrls: ['./radio_button_field.component.scss']
})

export class RadioButtonFieldComponent {

  // Control Settings - customizable by admin UI
  @Input("settings") settings : ControlSettings = {
    label: "Radio",
    description: "Choose One Option From Radio Buttons"
  };
  
  @Input("labelClass") labelClass : string = "col-sm-3 col-form-label col-form-label-sm";
  @Input("controlId") controlId : string = "";
  @Input("controlClass") controlClass : string = "col-sm-4";
  @Input("controlName") controlName : string | null = null;
  @Input("parentFormControl") parentFormControl : FormGroup | null = null;
  @Input("requiredErrorText") requiredErrorText : string | null = null;
  @Input("dangerColorCode") dangerColorCode : string | null = null;
  @Input("span1Class") span1Class : string | null = null;
  @Input("control1Value") control1Value : string | null = null;
  @Input("control1Label") control1Label : string | null = null;
  @Output() click1Event = new EventEmitter();
  @Output() click2Event = new EventEmitter();
  @Input("span2Class") span2Class : string | null = null;
  @Input("control2Value") control2Value : string | null = null;
  @Input("control2Label") control2Label : string | null = null;
  @Input("displayToolTip") displayToolTip : boolean = false;
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