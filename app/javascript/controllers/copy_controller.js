import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["code", "button"]
  static values = {
    default: String,
    copied: String
  }

  copy() {
    const text = this.codeTarget.innerText
    const originalText = this.defaultValue || "Copy"
    const copiedText = this.copiedValue || "Copied"

    navigator.clipboard.writeText(text).then(() => {
      this.buttonTarget.innerText = copiedText
      this.buttonTarget.disabled = true

      setTimeout(() => {
        this.buttonTarget.innerText = originalText
        this.buttonTarget.disabled = false
      }, 1500)
    })
  }
}
