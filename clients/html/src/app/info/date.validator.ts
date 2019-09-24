import { FormControl } from '@angular/forms';
import { max } from 'd3';

export function validateDate(control: FormControl) {
  let minDate = new Date("1900-01-01")
  let maxDate = new Date()
  let givenDate = new Date(control.value)
  if (givenDate < minDate || givenDate > maxDate) {
    return {
      invalidDate: true
    };
  }
  return null;
}
