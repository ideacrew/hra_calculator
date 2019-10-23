export function registerFileUploadEvents() {
  var uploadElements = document.getElementsByClassName('custom-file-input');
  if (uploadElements) {
    for (var i = 0, max = uploadElements.length; i < max; i++) {
      uploadElements[i].addEventListener('change', (event) => {
        var fileName = event.target.value.replace("C:\\fakepath\\", "");
        var parent = event.target.parentElement;
        var labelElement = parent.querySelector(".custom-file-label")

        labelElement.innerHTML = fileName;
      });
    }
  }
}