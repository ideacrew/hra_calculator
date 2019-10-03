import { FormControl } from '@angular/forms';
import { max } from 'd3';

export function validateDate(control: FormControl) {
	if(control.value && control.value.year && control.value.month && control.value.day){
	  let minDate = new Date("1900-01-01")
	  let maxDate = new Date()
	  let givenDate = new Date(`${control.value.year}-${control.value.month}-${control.value.day}`)
	  if (givenDate < minDate || givenDate > maxDate) {
	    return {
	      invalidDate: true
	    };
	  }
	}
  return null;
}

export function validateDateFormat(control: FormControl) {
	if(!(control.value && control.value.year && control.value.month && control.value.day)){
    return {
      invalidDateFormat: true
    };
  }
  return null;
}
