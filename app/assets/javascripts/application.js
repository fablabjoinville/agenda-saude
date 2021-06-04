//= require jquery
//= require jquery_ujs
//= require_tree .

$(document).ready(function(){
  $('.sp-celphones').mask(SPMaskBehavior, spOptions);
  $('input[data-sel="cpf"]').mask('999.999.999-99');
});

var SPMaskBehavior = function (val) {
  return val.replace(/\D/g, '').length === 11 ? '(00) 00000-0000' : '(00) 0000-00009';
},
spOptions = {
  onKeyPress: function(val, e, field, options) {
    field.mask(SPMaskBehavior.apply({}, arguments), options);
  }
};

// Enables and disables showing child checkboxes.
function groupToggle(parent) {
  let parentId = $(parent).data('group-parent')
  let child = $(`[data-group-child='${parentId}']`)

  if (child === undefined) return;

  if (parent.prop('checked')) {
    child.prop("hidden", false)
  } else {
    child.find('input').prop('checked', false)
    child.prop("hidden", true)
  }
}
