import { Controller } from "@hotwired/stimulus"

import toastr from "toastr";

export default class extends Controller {
  static targets = [];

  connect() {
    // console.log("aaa")
    let flash_key = this.data.get("key");
    let flash_value = this.data.get("value");
    
    // console.log(flash_key, flash_value);


    toastr.options = {
      debug: false,
      positionClass: "toastr-top-right",
      onclick: null,
      fadeIn: 300,
      fadeOut: 1000,
      timeOut: 5000,
      extendedTimeOut: 1000,
    };
    let temp=JSON.parse(flash_value)
    let n = temp.length;
    
    console.log(temp);
    for (let i = 0; i < n; i++) {
      console.log(temp[i]);
      switch (flash_key) {
        case "notice":
        case "success":
          toastr.success(temp[i]);
          break;
        case "info":
          toastr.info(temp[i]);
          break;
        case "warning":
          toastr.warning(temp[i]);
          break;
        case "alert":
        case "error":
          toastr.error(temp[i]);
          break;
        default:
          toastr.success(temp[i]);
      }
    }
  }
}
