function registerLanguageDelete() {
  const preferences = Array.from(document.querySelectorAll('#offered_languages .language_option button'));

  if (preferences != null) {
    preferences.forEach((element) => {
      element.addEventListener('click', (e) => {
        var lang_id = element.getAttribute('id').split('-')[1];
        document.querySelectorAll('#offered_languages .delete-language')[0].setAttribute('data-entity-id', lang_id);
      })
    })
  }

  const deleteButtons = Array.from(document.querySelectorAll('#offered_languages .delete-language'));

  if (deleteButtons != null) {
  deleteButtons.forEach((element) => {
    element.addEventListener('click', (e) => {
      
      var lang_id = element.getAttribute('data-entity-id');
      var locales_url = document.getElementById('delete_language_url').value;
      var request_url = locales_url + "?lang_id=" + lang_id;

      const xhr = new XMLHttpRequest();

      xhr.open('DELETE', request_url);
      xhr.send();

      xhr.onreadystatechange = (e) => {
        var language_element = document.getElementById('close-' + lang_id);
        language_element.parentNode.parentNode.removeChild(language_element.parentNode);
        document.getElementById('delete-cancel').click();
      }
    })
  })
 }

}

module.exports = {
  registerLanguageDelete: registerLanguageDelete
}