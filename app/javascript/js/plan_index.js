function registerPlanIndexEvents() {
  var selectElement = document.getElementById('benefit_year');

  selectElement.addEventListener('change', (event) => {
    var resultz = document.getElementById('serff_year');
    resultz.value = event.target.value;

    var result = document.getElementById('county_zip_year');
    if (result != null) {
      result.value = event.target.value;
    }
  });

  var uploadElements = document.getElementsByClassName('custom-file-input');
  for (var i = 0, max = uploadElements.length; i < max; i++) {

    uploadElements[i].addEventListener('change', (event) => {
      var fileName = event.target.value.replace("C:\\fakepath\\", "");
      var parent = event.target.parentElement;
      var labelElement = parent.querySelector(".custom-file-label")

      labelElement.innerHTML = fileName;
    });
  }
}

module.exports = {
  registerPlanIndexEvents: registerPlanIndexEvents
}