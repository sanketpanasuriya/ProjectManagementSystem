import Sortable from 'sortablejs';

let putarray = ['Created','On Going', 'Submitted', 'Re-Submitted', 'Rejected', 'Done'];

Sortable.create(Created, {
  group: {
    name: 'Created',
    put: putarray
  },
  draggable:".kanban-col-item",
  animation: 100,
  onEnd: function(evt) { 
    onEndFun(evt);
  }
});

Sortable.create(on_going, {
  group: {
    name: 'On Going',
    put: putarray
  },
  draggable:".kanban-col-item",
  animation: 100,
  onEnd: function(evt) { 
    onEndFun(evt);
  }
});

Sortable.create(Submitted, {
  group: {
    name: 'Submitted',
    put: putarray
  },
  animation: 100,
  draggable:".kanban-col-item",
  onEnd: function(evt) { 
    onEndFun(evt);
  }
});

Sortable.create(Re_Submitted, {
  group: {
    name: 'Re-Submitted',
    put:putarray
  },
  draggable:".kanban-col-item",
  animation: 100,
  onEnd: function(evt) { 
    onEndFun(evt);
  }
});

Sortable.create(Rejected, {
  group: {
    name: 'Rejected',
    put: putarray
  },
  draggable:".kanban-col-item",
  animation: 100,
  onEnd: function(evt) { 
    onEndFun(evt);
  }
});

Sortable.create(Done, {
  group: {
    name: 'Done',
    put: putarray
  },
  draggable:".kanban-col-item",
  animation: 100,
  onEnd: function(evt) { 
    onEndFun(evt);
  }
});


function onEndFun(/**Event*/evt) {
  var itemEl = evt.item;  // dragged HTMLElement
  // alert(itemEl.innerHTML);
  console.log(evt.to.getAttribute("id"));
  console.log(itemEl.getAttribute("data-id"));
  console.log(evt.newIndex);
  var status = evt.to.getAttribute("id");

  if(status == "on_going")
    status = "On Going";
  else if (status == "Re_Submitted")
    status = "Re-Submitted";
    
  $.ajax
  ({
    type: "patch",
    url: "/task/change_status",
    dataType: 'json',
    async: false,
    data: '{"id": "' + itemEl.getAttribute("data-id") + '", "status" : "' + status + '"}',
    success: function (x){
      console.log(x);
    },
    error: function(x) {
      alert("Something went wrong");
    } 
    
});
}
