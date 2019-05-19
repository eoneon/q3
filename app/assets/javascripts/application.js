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
  //show
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

  //TOGGLE CARET & SIBLING VIEWS
  $("body").on("click", ".caret-toggle", function(){
    var target = $(this);
    var form = thisForm($(this));
    var card_id = showCardId($(this));

    toggleCaretState(card_id, form);
    checkEditState(card_id, form);
    checkControlState(card_id);
    //console.log($(target).hasClass("caret-toggle"));
  });

  //TOGGLE ACCESS: toggle-edit-btn state
  $("body").on("click", ".edit-btn", function(){
    var form = thisForm($(this));
    var card_id = showCardId(form);
    toggleEditState(card_id, form);
    checkBodyState(card_id);
    checkControlState(card_id);
  });

  //TOGGLE ACCESS: toggle-parent state
  $("body").on("click", ".toggle-ctrl", function(){
    var form = thisForm($(this));
    var card_id = showCardId($(this));
    toggleControlState(card_id);
    checkEditState(card_id, form);
    checkBodyState(card_id);
    console.log(card_id);
  });

  //TOGGLE VIEW: hide item_group#add form upon background click
  $(document).on("click", function(e){
    var toggle_form = $(".toggle-form.show").eq(0);
    var toggle_parent = $(e.target).closest(".toggle-parent");
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

//traversal references
function showCardId(ref) {
  return '#'+$(ref).closest("div[id*='show']").attr("id"); //showCardId.replace("show", "body")
}
function thisForm(ref) {
  return $(ref).closest(".form");
}
function toggleParent(ref) {
  return $(ref).find(".card-header .toggle-parent");
}
function caretToggle(ref){
  return $(ref).find("button.caret-toggle");
}

//CARET TOGGLE STATE//
function toggleCaretState(card_id, form) {
  toggleCaret(form);
  //$(card_id).find(".card-header .caret-toggle i").toggleClass("fa-caret-right fa-caret-down");
  if ($(card_id).data("body-state") == 0) {
    toggleCaretStateOn(card_id);
    checkEditState(card_id, form);
    checkControlState(card_id);
  } else {
    toggleCaretStateOff(card_id);
  }
}
function toggleCaretStateOn(card_id) {
  $(card_id).data("body-state", 1);
  //$(card_id).find(".card-header").filter(".caret-toggle i.fa-caret-right").toggleClass("fa-caret-right fa-caret-down");
  collapseCaretSibs(card_id);
  //collapseCaretSib(card_id);
}
function toggleCaretStateOff(card_id) {
  $(card_id).data("body-state", 0);
  //$(card_id).find(".card-header").filter(".caret-toggle i.fa-caret-down").toggleClass("fa-caret-right fa-caret-down");
}
function collapseCaretSibs(card_id) {
  var card_sibs = $(card_id).siblings("div[id*='show'].card");
  $(card_sibs).find(".card-body.show").removeClass("show");
  $(card_sibs).data("body-state", 0);
  $(card_sibs).find("i.fa-caret-down").toggleClass("fa-caret-right fa-caret-down");
}
// function collapseCaretSib(card_id) {
//   //var card_sib = $(card_id).siblings("div[id*='show']").filter('[data-body-state="1"]');
//   var card_sib = $(card_id).siblings('[data-body-state="1"]');
//   if ($(card_sib).length) {
//     $(card_sib).data("body-state", 0);
//     $(card_sib).find("i.fa-caret-down").toggleClass("fa-caret-right fa-caret-down");
//     $(card_sib).find(".card-body").removeClass("show");
//   }
// }

//TEST STATE
function checkBodyState(card_id) {
  if ($(card_id).data("body-state") == 1) {
    $(card_id).data("body-state", 0);
    $(card_id).find(".card-header .caret-toggle i.fa-caret-down").toggleClass("fa-caret-right fa-caret-down");
    $(card_id).find(".card-body").removeClass("show");
  }
}
function checkEditState(card_id, form) {
  if ($(card_id).data("edit-state") == 1) {
    toggleEditState(card_id, form);
  }
}
function checkControlState(card_id) {
  if ($(card_id).data("control-state") == 1) {
    $(card_id).find(".card-header .toggle-form.show").removeClass("show");
    $(card_id).find(".card-header .toggle-parent.show").removeClass("show");
    toggleControlState(card_id);
  }
}

//TOGGLE
function toggleControlState(card_id) {
  if ($(card_id).data("control-state") == 1) {
    $(card_id).data("control-state", 0);
  } else {
    $(card_id).data("control-state", 1);
  }
}

function toggleEditState(card_id, form) {
  //var form = $(card_id).find(".card-header .form");
  var inputs = $(form).find("input.name-field, button.type-btn, button.delete-btn");
  $(form).find(".input-group-append button").toggleClass("show");
  $(form).find('.edit-btn').toggleClass("text-info text-secondary");
  setHiddenInputs(form);
  toggleInputs(inputs);
  if ($(card_id).data("edit-state") == 0) {
    $(card_id).data("edit-state", 1);
  } else {
    $(card_id).data("edit-state", 0);
  }
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
    var toggle_parent = $(toggle_form).closest(".toggle-parent");
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

function afterNestedCreate(card_id) {
  //var card_id = showCardId(form);
  //checkControlState(card_id);
  $(card_id).find(".card-header").find(".toggle-parent.show, .toggle-form.show").removeClass("show");
  $(card_id).find(".form .caret-toggle i").toggleClass("fa-caret-right fa-caret-down");
  //toggleCaret(form);
  $(card_id).data("body-state", 1);
  $(card_id).data("control-state", 1);
  $(card_id).find(".card-body").addClass("show");
}
//#CRUD: ADD: after item_group#create, toggle-hide form, toggle-show btn-group
function afterAdd(form_id) {
  var toggle_parent = $(form_id).closest(".toggle-parent");
  var toggle_form = $(form_id).closest(".toggle-form.show");
  toggleItemGroupCtrl(toggle_parent, toggle_form);
}
//#ADD form: item_group: toggle-show btn-group when background clicked
function toggleItemGroupCtrl(toggle_parent, toggle_form) {
  $(toggle_parent).find(".toggle-btn-group").add(toggle_form).toggleClass("show");
}

//CRUD functions//

//#SHOW: toggle insert/remove show card from index and reset tab-index
function toggleShowView(show_id, show_partial) {
  var id_arr = show_id.split('-');
  if ($(show_id).length == 0) {
    $(id_arr.splice(0,1).join(' ')).html(show_partial);
  // } else {
  //   $(show_id).remove();
  //   id_arr.splice(2,1, 'tab-item');
  //   $(id_arr.join('-')).removeClass("active");
  }
}

//#UPDATE: translate product_part:category/display btn click to checkbox checked and form submission
function checkBoxSubmit(form, check_box) {
  var status = $(check_box).prop("checked") == true ? false : true
  $(check_box).prop("checked", status);
  $(form).submit();
}

//#CREATE: toggle insert show card for created object, reset tab-index and add active class
function refreshCreate(show_id, tab_item_partial, show_partial){
  var tab_index_id = show_id.concat('-', 'tab-index');
  $(tab_index_id).find('.list-group-item').removeClass("active");
  $(tab_index_id).append(tab_item_partial);
  $(show_id).html(show_partial);
}

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
