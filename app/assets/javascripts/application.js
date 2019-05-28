// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery3
//= require jquery_ujs
//= require popper
//= require bootstrap-sprockets
//= require_tree .

$(document).ready(function(){

  //TOGGLE CARET & SIBLING VIEWS
  $("body").on("click", ".caret-toggle, .edit-toggle, .control-toggle", function(){
    var tags = ['show', 'body', 'caret-toggle', 'edit-toggle', 'control-toggle', 'parent-toggle'];
    var card_obj = objRef($(this), tags);
    detectToggleAction(card_obj);
  });

  //TOGGLE VIEW: hide item_group#add form upon background click
  $(document).on("click", function(e){
    var toggle_form = $(".toggle-form.show").eq(0);
    var toggle_parent = $(e.target).closest(".parent-toggle");
    collapseToggleFormIf(toggle_parent, toggle_form);
  });

  //TOGGLE VIEW: hide btn group upon selection
  $("body").on("click", ".form-opt, .close-form", function(){
    var href = $(this).attr("href");
    $(this).closest(".form").find("select").val('');
    $(this).closest(".col").removeClass("show");
  });

  //#SEARCH: handler for submitting search form: on dropdown selection
  $("body").on("change", ".search-select", function(){
    var form = $(this).closest(".form");
    $(form).submit();
  });

  //#CRUD SHOW
  $("body").on("click", "#tab-index a.list-group-item", function(e){
    var item_id = '#'+$(this).attr("id");
    var item_card_id = item_id.replace("tab-item", "show");
    var show_card = $('#show-card > .card');
    if ($(show_card).length && '#'+$(show_card).attr('id') == item_card_id){
      e.stopPropagation();
      e.preventDefault();
      $(item_card_id).remove();
      $(item_id).removeClass("active");
    }
  });

  //#CRUD EDIT: handler for submitting product_part form: on checkbox selection
  $("body").on("click", ".category-check", function(){
    var form = $(this).closest(".form");
    var check_box = $(form).find("input:checkbox.category");
    checkBoxSubmit(form, check_box);
  });

  //#CRUD EDIT
  $("body").on("click", ".display-check", function(){
    var form = $(this).closest(".form");
    var check_box = $(form).find("input:checkbox.display");
    checkBoxSubmit(form, check_box);
  });

  //#CRUD EDIT handler for enable/disable form with valid/present values
  $("body").on("change keyup", ".name-field, .type-field", function(){
    var form = $(this).closest(".form");
    enableSubmit(form);
  });

  //FORM ACCESS: product_part#new
  $("body").on("click", ".reset-btn", function() {
    var form = $(this).closest(".form");
    var a = $(form).find("a:first");
    resetDropdown(form, a);
    enableSubmit(form);
  });

  //FORM ACCESS: product_part#edit
  $("body").on("click", ".select-opt", function(){
    var a = $(this);
    var form = $(a).closest(".form");
    $(form).find(".type-label").text($(a).attr("data-name"));
    $(form).find("input:text.type-field").val($(a).attr("data-value"));
    enableSubmit(form);
    $(a).addClass("active").siblings().removeClass("active");
  });

});

function objRef(target, tags) {
  var card_obj = objIdAndTag(target);
  $.each(tags, function(i, tag) {
    card_obj[tag] = $(toId(card_obj["obj_id"],tag));
  });
  return card_obj;
}

function objIdAndTag(target) {
  var dom_id_arr = $(target).attr("id").split("-");
  var id_arr = $.grep(dom_id_arr, function(i, idx) {
    return $.isNumeric(i);
  });
  var idx = dom_id_arr.lastIndexOf(id_arr.pop())+1;
  return card_obj = {obj_id: dom_id_arr.slice(0, idx).join("-"), target: dom_id_arr.slice(idx).join("-")};
}

function toSnake(val) {
  return val.replace("-", "_");
}
function toId(val, tag) {
  return '#'+[val,tag].join("-");
}

//OBSOLETE
function objId(target) {
  return '#'+$(target).attr("id").split("-").slice(0,2).join("-");
}
//replaced by: card_obj["target"]
function toggleAction(target) {
  return $(target).attr("id").split("-").slice(2).join("-");
}
function showCardId(ref) {
  return '#'+$(ref).closest("div[id*='show']").attr("id");
}
function thisForm(ref) {
  return $(ref).closest(".form");
}
//END OBSOLETE

//traversal references
function detectToggleAction(card_obj) {
  if (card_obj["target"] == 'caret-toggle') {
	  toggleBodyState(card_obj);
  } else if (card_obj["target"] == 'edit-toggle') {
    toggleEditState(card_obj);
  } else if (card_obj["target"] == 'control-toggle') {
    toggleControlState(card_obj);
  }
}
function toggleBodyState(card_obj) {
  if (card_obj["caret-toggle"].find("i").hasClass("fa-caret-right")) {
    bodyStateOn(card_obj);
  } else {
    bodyStateOff(card_obj);
  }
}
function bodyStateOn(card_obj) {
  card_obj["caret-toggle"].find("i").toggleClass("fa-caret-right fa-caret-down");
  if (editState(card_obj)) toggleEdit(card_obj);
  if (card_obj["target"] == 'caret-toggle') collapseSibCardBody(card_obj["show"]);
  if (controlState(card_obj)) controlStateOff(card_obj);
  if (card_obj["target"] != 'caret-toggle') card_obj["body"].addClass("show");
}
function bodyStateOff(card_obj) {
  card_obj["caret-toggle"].find("i.fa-caret-down").toggleClass("fa-caret-right fa-caret-down");
  if (card_obj["target"] != "caret-toggle") card_obj["body"].removeClass("show");
}
function collapseSibCardBody(card) {
  var sib_card = $(card).siblings("div[id*='show']").has(".card-body.show");
  if ($(sib_card).length) {
    $(sib_card).find(".card-body").removeClass("show");
    $(sib_card).find("i.fa-caret-down").toggleClass("fa-caret-right fa-caret-down");
  }
}
function bodyState(card_obj) {
  if (card_obj["body"]) return card_obj["body"].hasClass("show");
}
function editState(card_obj) {
  if (card_obj["edit-toggle"]) return card_obj["edit-toggle"].find("span").hasClass("text-info");
}
function controlState(card_obj) {
  if (card_obj["parent-toggle"]) return card_obj["parent-toggle"].hasClass("show");
}
function toggleEditState(card_obj) {
  toggleEdit(card_obj);
  if (bodyState(card_obj)) bodyStateOff(card_obj);
  if (controlState(card_obj)) controlStateOff(card_obj);
}
function toggleEdit(card_obj) {
  var form = card_obj["edit-toggle"].closest(".form");
  var inputs = $(form).find("input.name-field, button.type-btn, button.delete-btn");
  $(form).find(".input-group-append button").toggleClass("show");
  card_obj["edit-toggle"].find("span").toggleClass("text-info text-secondary");
  setHiddenInputs(form);
  toggleInputs(inputs);
}
function toggleControlState(card_obj) {
  if (!controlState(card_obj)) {
    controlStateOn(card_obj);
  }
}
function controlStateOn(card_obj) {
  if (editState(card_obj)) toggleEdit(card_obj);
  if (bodyState(card_obj)) bodyStateOff(card_obj);
}
function controlStateOff(card_obj) {
  card_obj["parent-toggle"].removeClass("show");
}
//end new

//OBSOLUTE?

function toggleParent(ref) {
  return $(ref).find(".card-header .parent-toggle");
}
function caretToggle(ref){
  return $(ref).find("button.caret-toggle");
}
function toggleCaret(ref) {
  $(ref).find(".caret-toggle i").toggleClass("fa-caret-right fa-caret-down");
}
function disabledStatus(ref, field) {
  $(ref).find('.'+field).prop("disabled");
}

//background click: afterBackgroundClick
function collapseToggleFormIf(toggle_parent, toggle_form) {
  if ($(toggle_form).length && !$(toggle_parent).find(toggle_form).length) {
    var toggle_parent = $(toggle_form).closest(".parent-toggle");
    toggleItemGroupCtrl(toggle_parent, toggle_form);
    $(toggle_form).find("select").val('');
  }
}
//FORM ACCESS: named functions//

//#NEW: clear :type/:name fields, reset data attrs and remove active class from a options
function resetDropdown(form, a) {
  $(form).find(".type-label").text($(a).attr("data-name"));
  $(form).find("input:text").val($(a).attr("data-value"));
  $(a).addClass("active").siblings().removeClass("active");
}

//#NEW/#EDIT: disable submit if invalid/missing :type/:name
function enableSubmit(form) {
  var access = $(form).find(".name-field").val().length  && $(form).find(".type-field").val().length ? false : true
  $(form).find("button:submit").prop("disabled", access);
}

//#EDIT FORM: replaces toggleDisable
function toggleInputs(input_set){
  $(input_set).each(function(i, input){
    $(input).attr("disabled") == "disabled" ? $(input).attr("disabled", false) : $(input).attr("disabled", true)
  });
}

//#EDIT FORM:
function setHiddenInputs(form) {
  var type = $(form).find("input:hidden[name='type']").val();
  var name = $(form).find("input:hidden[name='name']").val();
  $(form).find("span.type-label").text(type);
  $(form).find("input.name-field").val(name);
}
function afterNestedCreate(target) {
  var tags = ['show', 'body', 'caret-toggle', 'parent-toggle'];
  var card_obj = objRef(target, tags)
  //var obj_id = "#"+ref.split("-").slice(0,2).join("-");
  //var card_obj = {obj_id: obj_id, toggle_action: "create", parent_card: $(obj_id+'-'+'show'), card_body: $(obj_id+'-'+'body'), caret_toggle: $(obj_id+'-'+'caret-toggle'), toggle_parent: $(obj_id+'-'+'parent-toggle')};
  bodyStateOn(card_obj);
}

//#CRUD: ADD: after item_group#create, toggle-hide form, toggle-show btn-group
function afterAdd(form_id) {
  var toggle_parent = $(form_id).closest(".parent-toggle");
  var toggle_form = $(form_id).closest(".toggle-form.show");
  toggleItemGroupCtrl(toggle_parent, toggle_form);
}
//#ADD form: item_group: toggle-show btn-group when background clicked
function toggleItemGroupCtrl(toggle_parent, toggle_form) {
  $(toggle_parent).find(".btn-group-toggle").add(toggle_form).toggleClass("show");
}

//CRUD functions//

//#SHOW: toggle insert/remove show card from index and reset tab-index
function toggleShowView(show_id, show_partial) {
  var id_arr = show_id.split('-');
  if ($(show_id).length == 0) {
    $(id_arr.splice(0,1).join(' ')).html(show_partial);
  }
}

//#UPDATE: translate product_part:category/display btn click to checkbox checked and form submission
function checkBoxSubmit(form, check_box) {
  var status = $(check_box).prop("checked") == true ? false : true
  $(check_box).prop("checked", status);
  $(form).submit();
}

//#CREATE: toggle insert show card for created object, reset tab-index and add active class
// function refreshCreate(show_id, tab_item_partial, show_partial){
//   var tab_index_id = show_id.concat('-', 'tab-index');
//   $(tab_index_id).find('.list-group-item').removeClass("active");
//   $(tab_index_id).append(tab_item_partial);
//   $(show_id).html(show_partial);
// }

function enableCustomInputs() {
  $("input:radio[value='custom']:checked").closest(".col").find("input:text").prop("disabled", false);
}
//obsolete?
function resetDropdownOptions(id){
  return $('a[href="#'+id+'"]').prop("disabled", true).addClass("disabled").siblings().prop("disabled", false).removeClass("disabled");
}

function addOption(form, id, name){
  $(form).find("option:last").after("<option value='"+id+"'>"+name+"</option>");
}
function removeOption(form, id){
  $(form).find("option[value='"+id+"']").hide();
}
//getter functions
function getInputs(form) {
  return $(form).find("input:text, select, button:submit, button.category-check, button.display-check");
}
function getCheckInput(form) {
  return $(form).find("input:checkbox[name=category]").val();
}

//sub_parts/create.js
function getInputGroupDiv(form) {
  return $(form).find("div.input-group");
}

// function getCategoryInput(form) {
//   return $(form).find("input:checkbox.category");
// }
