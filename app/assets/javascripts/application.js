//= require jquery
//= require jquery_ujs
//= require_tree .

$(document).ready(function(){
  $('.sp_celphones').mask(SPMaskBehavior, spOptions);
});

var SPMaskBehavior = function (val) {
  return val.replace(/\D/g, '').length === 11 ? '(00) 00000-0000' : '(00) 0000-00009';
},
spOptions = {
  onKeyPress: function(val, e, field, options) {
      field.mask(SPMaskBehavior.apply({}, arguments), options);
    }
};

