function registerTranslationEvents() {

  function addTranslationNavHandlers() {
    const elements = document.querySelectorAll('#translations .nav-item');

    elements.forEach((element) => {
      element.addEventListener('click', (e) => {
        var currentElement  = e.currentTarget;
        var translation_key = currentElement.textContent;

        var page_element    = document.getElementById('ui_page').value;
        var translate_from  = document.getElementById('translate_from').value;
        var translate_to    = document.getElementById('translate_to').value;
        var edit_translation_url = document.getElementById('edit_translation_url').value;        
        
        var request_url = edit_translation_url + "?page=" + page_element + "&from_locale=" + translate_from +"&to_locale=" + translate_to + "&translation_key=" + translation_key;

        const xhr = new XMLHttpRequest();

        // xhr.dataType = 'script';
        xhr.open('GET', request_url);
        xhr.send();

        xhr.onreadystatechange = (e) => {
          document.getElementById('edit_translation').innerHTML = xhr.responseText;
        }
      })
    })
  }

  addTranslationNavHandlers();

  const preferences = document.querySelectorAll('#ui_page, #translate_from, #translate_to');

  preferences.forEach((element) => {
    element.addEventListener('change', (e) => {
      var page_element    = document.getElementById('ui_page').value;
      var translate_from  = document.getElementById('translate_from').value;
      var translate_to    = document.getElementById('translate_to').value;
      var locales_url = document.getElementById('fetch_locales_url').value;
      var request_url = locales_url + "?page=" + page_element + "&from_locale=" + translate_from +"&to_locale=" + translate_to;

      const xhr = new XMLHttpRequest();

      // xhr.dataType = 'script';
      xhr.open('GET', request_url);
      xhr.send();

      xhr.onreadystatechange = (e) => {
        document.getElementById('translations').innerHTML = xhr.responseText;
        addTranslationNavHandlers();
      }
    })
  })
}

module.exports = {
  registerTranslationEvents: registerTranslationEvents
}