import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["choice"]

  connect() {
    if (this.element.classList.contains("choose-best")) {
      this.setupChooseBest()
    } else if (this.element.classList.contains("choose-all")) {
      this.setupChooseAll()
    }
  }

  setupChooseAll() {
    this.element.querySelectorAll("input[type=checkbox]").forEach((checkbox) => {
      checkbox.addEventListener("change", () => this.checkChooseAllAnswers())
    })
  }

  setupChooseBest() {
    this.element.querySelectorAll("input[type=radio]").forEach((radio) => {
      radio.addEventListener("change", () => this.checkChooseBestAnswer())
    })
  }

  checkChooseBestAnswer() {
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

  checkChooseAllAnswers() {
    const correctAnswers = JSON.parse(this.data.get("answer") || "[]").map(String)
    const selected = Array.from(this.element.querySelectorAll("input[type=checkbox]:checked"))
                          .map(input => input.value)

    this.element.classList.add("attempted")

    this.choiceTargets.forEach((choice) => {
      const index = choice.dataset.quizChoiceIndex
      const feedback = choice.querySelector(".quiz-feedback")
      const isCorrect = correctAnswers.includes(index)
      const isSelected = selected.includes(index)

      choice.classList.remove("is-correct", "is-wrong")
      if (feedback) feedback.style.display = "none"

      if (isSelected) {
        choice.classList.add(isCorrect ? "is-correct" : "is-wrong")
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
