import { registerFileUploadEvents } from './file_upload';

export function registerPlanIndexEvents() {
  var selectElement = document.getElementById('benefit_year');

  selectElement.addEventListener('change', (event) => {
    var resultz = document.getElementById('serff_year');
    resultz.value = event.target.value;

    var result = document.getElementById('county_zip_year');
    if (result != null) {
      result.value = event.target.value;
    }
  });
  registerFileUploadEvents();
}