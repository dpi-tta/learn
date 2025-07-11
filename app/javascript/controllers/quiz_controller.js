import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["choice"]

  connect() {
    if (this.element.classList.contains("choose-best")) {
      this.setupRadioInputs()
    }
  }

  setupRadioInputs() {
    this.element.querySelectorAll("input[type=radio]").forEach((radio) => {
      radio.addEventListener("change", () => this.checkAnswer())
    })
  }

  checkAnswer() {
    const correct = String(this.data.get("answer"))
    const selected = this.element.querySelector("input[type=radio]:checked")
    if (!selected) return

    const selectedIndex = selected.value
    this.element.classList.add("attempted")

    this.choiceTargets.forEach((choice) => {
      const index = String(choice.dataset.quizChoiceIndex)
      const feedback = choice.querySelector(".quiz-feedback")

      choice.classList.remove("is-correct", "is-wrong")
      if (feedback) feedback.style.display = "none"

      if (index === selectedIndex) {
        if (index === correct) {
          choice.classList.add("is-correct")
        } else {
          choice.classList.add("is-wrong")
        }
        if (feedback) feedback.style.display = "block"
      }
    })
  }

  validateFreeText(event) {
    const input = event.target
    const value = input.value.trim()

    input.classList.toggle("is-invalid", value === "")
    input.classList.toggle("is-valid", value !== "")
  }
}
