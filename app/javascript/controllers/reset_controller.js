import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  resetform() {
    document.getElementById('modal').remove();
  }
}
