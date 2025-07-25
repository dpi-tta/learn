import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="course-lesson-selector"
export default class extends Controller {
  static targets = ["search", "results", "selected"]

  connect() {
    this.searchTarget.addEventListener("input", () => this.search())
  }

  async search() {
    const query = this.searchTarget.value.trim()
    if (query.length < 2) {
      this.resultsTarget.innerHTML = ""
      return
    }

    try {
      const raw = await fetch(`/lessons.json?q=${encodeURIComponent(query)}`)
      const json = await raw.json()

      this.resultsTarget.innerHTML = json.map(lesson => `
        <div class="d-flex justify-content-between align-items-center mb-2">
          <span>${lesson.title}</span>
          <button type="button"
                  class="btn btn-sm btn-success"
                  data-action="course-lesson-selector#addLesson"
                  data-lesson-id="${lesson.id}"
                  data-lesson-title="${lesson.title}">
            Add
          </button>
        </div>
      `).join("")
    } catch (error) {
      console.error("Search error:", error)
    }
  }

  addLesson(event) {
    const button = event.target
    const lessonId = button.dataset.lessonId
    const lessonTitle = button.dataset.lessonTitle

    if (!lessonId || !lessonTitle) return

    const existing = this.selectedTarget.querySelector(`[data-lesson-id="${lessonId}"]`)
    if (existing) return

    const container = document.createElement("div")
    container.className = "card mb-3 position-relative"
    container.setAttribute("data-lesson-id", lessonId)

    container.innerHTML = `
      <div class="card-body">
        <button type="button"
                class="btn-close position-absolute top-0 end-0 m-2"
                aria-label="Remove"
                data-action="course-lesson-selector#removeLesson"></button>

        <h5 class="card-title">${lessonTitle}</h5>

        <input type="hidden" name="course[course_lessons_attributes][][lesson_id]" value="${lessonId}" />
        <input type="text" name="course[course_lessons_attributes][][position]" class="form-control mb-2" placeholder="Position" />
        <input type="hidden" name="course[course_lessons_attributes][][_destroy]" value="false" />
      </div>
    `
    this.selectedTarget.appendChild(container)
  }

  removeLesson(event) {
    const container = event.target.closest("[data-lesson-id]")
    const destroyInput = container.querySelector('input[name*="_destroy"]')
    if (destroyInput) {
      destroyInput.value = "1"
      container.style.display = "none"
    } else {
      // fallback for new records that aren’t saved yet
      container.remove()
    }
  }
}
