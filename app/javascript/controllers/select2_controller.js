
import { Controller } from "@hotwired/stimulus";
import $ from "jquery";
import select2 from 'select2';
export default class extends Controller   {
  connect(event) {
     select2($);

      $('.js-example-basic-multiple').select2({
        templateResult: formatState
      });
           
      
  }
  initialize()	
  {
    select2($);

    var $exampleMulti = $(".js-example-basic-multiple").select2();

    var  selected_item=this.element.getAttribute("data-selectedtag"); 
    selected_item=JSON.parse(selected_item)
    
    // $exampleMulti.val([12, 16, 18, 17, 19, 20]).trigger("change");
    $exampleMulti.val(selected_item).trigger("change");

  }
  
}
function formatState (state) {
  if (!state.id) {
    return state.text;
  }
  var $state = $(
    '<span> <span class="dot" style="background-color:'+state.element.getAttribute("color")+ ' ;"></span> ' + state.text + '</span>'
  );
  return $state;
};
function addSelectedTag (tag) {
  var $exampleMulti = $(".js-example-basic-multiple").select2();
  $exampleMulti.val(tag).trigger("change");

}