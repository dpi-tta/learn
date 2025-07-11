// app/javascript/controllers/prism_controller.js
import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  connect() {
    // NOTE: ensure Prism runs every time Turbo loads a page
    if (window.Prism) Prism.highlightAll();
  }
}
