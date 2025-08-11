import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["editor", "output", "runButton", "resetButton"]
  static values = { language: String }

  static runnerUrl = "/runner/execute"

  connect() {
    this.observeTheme()
    this.initialCode = this.editorTarget.value.trim()
    this.autoResizeEditor()

    // initialize output to empty so it applies theme
    this.setOutput(this.wrapInHtml(""))
  }

  disconnect() {
    this.themeObserver?.disconnect()
  }

  async run() {
    this.showSpinner()
    const code = this.editorTarget.value
    
    if (this.languageValue === "ruby") {
      const plain = await this.executeRemotely(code)
      this.setOutput(this.wrapInHtml(plain))
    } else {
      this.setOutput(code)
    }

    this.hideSpinner()
  }

  reset() {
    this.editorTarget.value = this.initialCode
    this.setOutput(this.wrapInHtml(""))
  }

  showSpinner() {
    if (!this.hasRunButtonTarget) return

    this._buttonHTML = this.runButtonTarget.innerHTML
    this.runButtonTarget.disabled = true
    this.runButtonTarget.innerHTML = `<i class="bi bi-arrow-repeat spin me-2"></i>Running...`
  }

  hideSpinner() {
    if (!this.hasRunButtonTarget) return

    this.runButtonTarget.disabled = false
    this.runButtonTarget.innerHTML = this._buttonHTML
  }

  currentTheme() {
    // fallback to prefers-color-scheme if attribute isn't set
    return document.documentElement.getAttribute('data-bs-theme') || (window.matchMedia('(prefers-color-scheme: dark)').matches ? 'dark' : 'light')
  }

  observeTheme() {
    const apply = () => {
      this.theme = this.currentTheme()
      // if an iframe is already rendered, update it in-place with theme
      const documentElement = this.outputTarget.contentDocument?.documentElement
      if (documentElement) {
        documentElement.setAttribute('data-bs-theme', this.theme)
      }
    }

    apply()
    this.themeObserver = new MutationObserver(apply)
    this.themeObserver.observe(document.documentElement, {
      attributes: true, attributeFilter: ['data-bs-theme']
    })
  }

  setOutput(html) {
    this.outputTarget.onload = () => this.resizeOutput()
    this.outputTarget.srcdoc = html
  }

  autoResizeEditor() {
    this.editorTarget.style.height = "auto"
    this.editorTarget.style.height = `${this.editorTarget.scrollHeight}px`
  }

  resizeOutput() {
    const minHeight = 200
    try {
      const body = this.outputTarget.contentDocument.body
      const height = body.scrollHeight
      this.outputTarget.style.height = `${Math.max(height + 4, minHeight)}px`
    } catch {
      this.outputTarget.style.height = `${minHeight}px`
    }
  }

  async executeRemotely(code) {
    try {
      const response  = await fetch(this.constructor.runnerUrl, {
        method:  "POST",
        headers: { "Content-Type": "application/json" },
        body:    JSON.stringify({ code })
      })

      const json = await response.json()
      if (!response.ok) throw json // eg { error: "...", ... }

      // TODO: show a message when no output?
      return json.stderr?.trim() ? json.stderr : json.stdout
    } catch (e) {
      return `Error: ${e.error || e.message || e}`
    }
  }

  wrapInHtml(text) {
    const theme = this.theme || this.currentTheme()
    return `
      <!DOCTYPE html>
      <html data-bs-theme="${theme}">
      <head>
        <meta charset="UTF-8">
        <!-- NOTE: this css is repeated in repl_controller.js -->
        <style>
          html, body {
            margin: 0;
            height: 100%;
          }

          html[data-bs-theme="dark"]  {
            background: #1a1a1a;
            color: #e5e5e5;
          }

          html[data-bs-theme="light"] {
            background: #ffffff;
            color: #212529;
          }

          /* Terminal block */
          pre {
            font-family: monospace;
            font-size: 1rem;
            white-space: pre;
            margin: 0;
            overflow-x: auto;
          }
        </style>
      </head>
      <body>
        <pre>${this.escapeHTML(text)}</pre>
      </body>
      </html>
    `
  }

  escapeHTML(str) {
    return str
      .replace(/&/g, "&amp;")
      .replace(/</g, "&lt;")
      .replace(/>/g, "&gt;")
  }
}
