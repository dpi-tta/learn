// assets/js/controllers/theme_toggle_controller.js
import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["button", "icon", "label"];
  static values = {
    storageKey: { type: String, default: "theme" }
  }

  connect() {
    this.syncTheme();
    window.matchMedia("(prefers-color-scheme: dark)").addEventListener("change", () => {
      if (!this.getStoredTheme()) this.applyTheme("auto");
    });
  }

  cycle() {
    const current = this.getStoredTheme() || "auto";
    const next = this.getNextTheme(current);
    localStorage.setItem(this.storageKeyValue, next);
    this.applyTheme(next, true); // trigger animation
  }

  syncTheme() {
    const stored = this.getStoredTheme();
    const theme = stored || this.getPreferredTheme();
    this.applyTheme(theme);
  }

  applyTheme(theme, animate = false) {
    if (theme === "auto") {
      if (window.matchMedia("(prefers-color-scheme: dark)").matches) {
        document.documentElement.setAttribute("data-bs-theme", "dark");
      } else {
        document.documentElement.setAttribute("data-bs-theme", "light");
      }
    } else {
      document.documentElement.setAttribute("data-bs-theme", theme);
    }

    const iconMap = {
      auto: "🖥️",
      dark: "🌙",
      light: "🌞"
    };

    const labelMap = {
      auto: "System",
      dark: "Dark",
      light: "Light"
    };

    if (animate) {
      this.animateSwap(this.iconTarget, iconMap[theme]);
      this.animateSwap(this.labelTarget, labelMap[theme]);
    } else {
      this.iconTarget.textContent = iconMap[theme];
      this.labelTarget.textContent = labelMap[theme];
    }
  }

  animateSwap(element, newContent) {
    element.classList.add("fade-out");
    setTimeout(() => {
      element.textContent = newContent;
      element.classList.remove("fade-out");
      element.classList.add("fade-in");
      setTimeout(() => {
        element.classList.remove("fade-in");
      }, 150);
    }, 150);
  }

  getStoredTheme() {
    return localStorage.getItem(this.storageKeyValue);
  }

  getPreferredTheme() {
    return window.matchMedia("(prefers-color-scheme: dark)").matches ? "dark" : "light";
  }

  getNextTheme(current) {
    return {
      auto: "dark",
      dark: "light",
      light: "auto"
    }[current];
  }
}
