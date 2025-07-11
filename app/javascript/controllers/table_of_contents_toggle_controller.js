// controllers/toc_toggle_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["icon"]

  connect() {
    const collapseElement = document.querySelector(this.element.dataset.bsTarget)
    if (!collapseElement) return

    collapseElement.addEventListener("show.bs.collapse", () => {
      this.iconTarget.classList.remove("bi-arrows-vertical")
      this.iconTarget.classList.add("bi-arrows-collapse")
    })

    collapseElement.addEventListener("hide.bs.collapse", () => {
      this.iconTarget.classList.remove("bi-arrows-collapse")
      this.iconTarget.classList.add("bi-arrows-vertical")
    })
  }
}
