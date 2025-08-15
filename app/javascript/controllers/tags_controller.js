import { Controller } from "@hotwired/stimulus";

// data-controller="tags"
// data-tags-name-value="plat[sauce_list][]"  <-- nom des inputs cachés à générer
export default class extends Controller {
  static targets = ["input", "container"];
  static values  = { name: String, suggestions: Array };

  connect() {}

  keydown(event) {
    if (event.key === "Enter" || event.key === ",") {
      event.preventDefault();
      const raw = this.inputTarget.value;
      this.inputTarget.value = "";
      this.addMany(raw);
    }
  }

  addFromClick(event) {
    const v = event.currentTarget.dataset.value;
    this.addOne(v);
  }

  addMany(str) {
    const parts = String(str).split(",").map(s => s.trim()).filter(Boolean);
    parts.forEach(v => this.addOne(v));
  }

  addOne(v) {
    const value = v.toLowerCase().trim();
    if (!value) return;
    if (this.hasHidden(value)) return;

    // chip
    const chip = document.createElement("span");
    chip.className = "tag";
    chip.innerHTML = `
      ${value}
      <button type="button" aria-label="Supprimer" data-action="click->tags#remove" data-tag="${value}">&times;</button>
    `;
    this.containerTarget.appendChild(chip);

    // hidden
    const hidden = document.createElement("input");
    hidden.type  = "hidden";
    hidden.name  = this.nameValue;
    hidden.value = value;
    this.element.appendChild(hidden);
  }

  remove(event) {
    const value = event.currentTarget.dataset.tag;
    // remove chip
    event.currentTarget.closest(".tag")?.remove();
    // remove hiddens
    this.element.querySelectorAll(`input[type="hidden"][name="${this.nameValue}"][value="${value}"]`).forEach(n => n.remove());
  }

  hasHidden(value) {
    return !!this.element.querySelector(`input[type="hidden"][name="${this.nameValue}"][value="${value}"]`);
  }
}
