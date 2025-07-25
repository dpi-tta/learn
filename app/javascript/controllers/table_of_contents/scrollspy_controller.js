import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="table-of-contents--scrollspy"
export default class extends Controller {
  static targets = ["ul"]

  connect() {
    this.headings = document.querySelectorAll("h2, h3, h4, h5, h6[id]")

    window.addEventListener("scroll", this.onScroll.bind(this))
    this.onScroll() // initialize state
  }

  disconnect() {
    window.removeEventListener("scroll", this.onScroll.bind(this))
  }

  onScroll() {
    let currentId = null

    this.headings.forEach((heading) => {
      const rect = heading.getBoundingClientRect()
      if (rect.top <= 100) {
        currentId = heading.id
      }
    })

    if (currentId == null) return;

    this.ulTarget.querySelectorAll("a.nav-link").forEach((link) => {
      if (link.getAttribute("href") === `#${currentId}`) {
        link.classList.add("active")
      } else {
        link.classList.remove("active")
      }
    })
  }
}
