import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["editor", "output"]
  static values = { language: String }

  connect() {
    this.initialCode = this.editorTarget.value.trim()
    this.autoResizeEditor()
  }

  run() {
    const code = this.editorTarget.value
    this.outputTarget.srcdoc = code
    this.outputTarget.onload = () => this.resizeOutput()
  }

  reset() {
    this.editorTarget.value = this.initialCode
    this.outputTarget.srcdoc = "<!DOCTYPE html><html><body></body></html>"
  }

  autoResizeEditor() {
    this.editorTarget.style.height = "auto"
    this.editorTarget.style.height = this.editorTarget.scrollHeight + "px"
  }

  resizeOutput() {
    try {
      const body = this.outputTarget.contentDocument.body
      const height = body.scrollHeight
      this.outputTarget.style.height = `${Math.max(height + 20, 200)}px`
    } catch (e) {
      console.warn("Unable to auto-resize output:", e)
      this.outputTarget.style.height = "200px"
    }
  }
}
