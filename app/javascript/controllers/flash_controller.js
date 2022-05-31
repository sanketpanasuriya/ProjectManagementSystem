import { Controller } from "@hotwired/stimulus"

import toastr from "toastr";

export default class extends Controller {
  static targets = [];

  connect() {
    let flash_key = this.data.get("key");
    let flash_value = this.data.get("value");
    console.log(flash_key, flash_value);
    

    toastr.options = {
      debug: false,
      positionClass: "toastr-top-right",
      onclick: null,
      fadeIn: 300,
      fadeOut: 1000,
      timeOut: 5000,
      extendedTimeOut: 1000,
    };

    switch (flash_key) {
      case "notice":
      case "success":
        toastr.success(flash_value);
        break;
      case "info":
        toastr.info(flash_value);
        break;
      case "warning":
        toastr.warning(flash_value);
        break;
      case "alert":
      case "error":
        toastr.error(flash_value);
        break;
      default:
        toastr.success(flash_value);
    }
  }
}
