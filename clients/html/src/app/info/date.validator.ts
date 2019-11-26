import { FormControl } from '@angular/forms';

export function validateDate(control: FormControl) {
  if (
    control.value &&
    control.value.year &&
    control.value.month &&
    control.value.day
  ) {
    const minDate = new Date('1900-01-01');
    const maxDate = new Date();
    const givenDate = new Date(
      `${control.value.year}-${control.value.month}-${control.value.day}`
    );
    if (givenDate < minDate || givenDate > maxDate) {
      return {
        invalidDate: true
      };
    }
  }
  return null;
}

export function validateDateFormat(control: FormControl) {
  if (
    !(
      control.value &&
      control.value.year &&
      control.value.month &&
      control.value.day
    )
  ) {
    return {
      invalidDateFormat: true
    };
  }
  return null;
}
