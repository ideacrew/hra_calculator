const selectElements = document.querySelectorAll('input.js-color-swatch');
const colorPattern = /^\#([a-fA-F0-9]{6}|[a-fA-F0-9]{3})$/

for (const selectElement of selectElements) {
  selectElement.addEventListener('change', (e) => {
    if (e.currentTarget.value.match(colorPattern)) {
      e.currentTarget.classList.remove('is-invalid')

      var feedback = e.currentTarget.parentNode.querySelector('.invalid-feedback') !== null
      if (feedback)
        feedback.remove()

      var color = e.currentTarget.value
      e.currentTarget.parentNode.querySelector('button').setAttribute("style", `background-color: ${color}`)
    } else {
      if (!e.currentTarget.classList.contains('is-invalid')) {
        e.currentTarget.classList.add('is-invalid')
        var feedback = document.createElement('div')
        feedback.classList.add('invalid-feedback')
        feedback.innerHTML = 'Not a valid RGB value.'
        e.currentTarget.parentNode.appendChild(feedback)
      }
    }
  });
}
