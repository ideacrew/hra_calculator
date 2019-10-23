function registerLanguageDelete() {
  const preferences = document.querySelectorAll('#offered_languages .language_option button');

  preferences.forEach((element) => {
    element.addEventListener('click', (e) => {

      var lang_id = element.getAttribute('id').split('-')[1];;
      var locales_url = document.getElementById('delete_language_url').value;
      var request_url = locales_url + "?lang_id=" + lang_id;

      const xhr = new XMLHttpRequest();

      xhr.open('DELETE', request_url);
      xhr.send();

      xhr.onreadystatechange = (e) => {
        element.parentNode.parentNode.removeChild(element.parentNode);
      }
    })
  })
}

module.exports = {
  registerLanguageDelete: registerLanguageDelete
}