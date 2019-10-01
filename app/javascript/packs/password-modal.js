require('bootstrap.native/dist/bootstrap-native-v4.js')
import "bootstrap.native"
import { Modal } from "bootstrap.native"

const passwordModalElement = document.querySelector('#passwordModal')
const passwordModalLinks = document.querySelectorAll('.js-change-password-link')

passwordModalLinks.forEach((passwordModalLink) => {
  passwordModalLink.addEventListener('click', (e) => {
    var id = e.currentTarget.dataset.accountId
    var email = e.currentTarget.dataset.accountEmail

    passwordModalElement.querySelector('.js-account-email').innerHTML = email
    var form = passwordModalElement.querySelector('form')
    form.setAttribute('action',
      form.attributes.action.value.replace(/accounts\/[^\/]*\/password/,
        `accounts/${id}/password`))
    var passwordModal = new Modal(passwordModalElement, {});
    passwordModal.show()
  })
})

passwordModalElement.addEventListener('hide.bs.modal', (e) => {
  passwordModalElement.querySelectorAll('input[type=password]').forEach((input) => {
    input.value = ''
  })
})

function passwordModal() {
  const passwordModalElement = document.querySelector('#passwordModal')
  var passwordModal = new Modal(passwordModalElement, {});
  return passwordModal
}

window.passwordModal = passwordModal()
