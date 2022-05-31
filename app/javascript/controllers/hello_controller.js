import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    console.log("a");
    this.element.textContent = "Hello World!"
  }
}
