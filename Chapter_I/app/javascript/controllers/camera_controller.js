import { Controller } from "@hotwired/stimulus"
import { passwordStrength } from 'check-password-strength'

export default class extends Controller {
  static targets = ['password', 'output']

  connect() {
    this.checkStrength()
  }

  checkStrength() {
    this.outputTarget.textContent = passwordStrength(this.passwordTarget.value).value
  }

}
