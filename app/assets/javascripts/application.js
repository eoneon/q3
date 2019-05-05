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
  $("body").on("click", ".caret-toggle", function(){
    $(this).find("i").toggleClass("fa-caret-right fa-caret-down");
  });

  $(document).on("click", function(e){
    var toggle_form = $(".toggle-form.show").eq(0);
    var target_form = $(e.target).closest(".toggle-parent").find(toggle_form);
    if ($(toggle_form).length && !$(target_form).length) {
      $(toggle_form).removeClass("show");
      $(toggle_form).closest(".toggle-parent").find(".toggle-btn-group").addClass("show");
    }
  });

  $("body").on("click", ".form-opt, .nav-toggle", function(){
    var href = $(this).attr("href");
    $(this).closest(".col").removeClass("show"); 
  });

  //toggle-edit-btn
  $("body").on("click", ".edit-btn", function(){
    $(this).toggleClass("text-info text-secondary");
    var form = $(this).closest(".form");
    var inputs = $(form).find("input.name-field, button.caret-toggle, button.type-btn, button.delete-btn");
    var type = $(form).find("input:hidden[name='type']").val();
    var name = $(form).find("input:hidden[name='name']").val();
    $(form).find("span.type-label").text(type);
    $(form).find("input.name-field").val(name);
    toggleDisable(inputs);
    $(form).find(".input-group-append button").toggleClass("show");
  });

  //toggle siblings: show/hide
  $("body").on("show.bs.collapse", ".card-body", function(){
    var card_sibs = $(this).closest("div[id*='show']").siblings();
    $(card_sibs).find(".card-body").removeClass("show");
    $(card_sibs).find("button.caret-toggle").find("i.fa-caret-down").toggleClass("fa-caret-down fa-caret-right");
  });

  $("body").on("click", ".toggle-input-access", function(){
    var form = $(this).closest(".form");
    toggleInputAndDelete(form);
  });

  $("body").on("hidden.bs.collapse", ".toggle-sibling", function(){
    var form = $(this).find(".form");
    if (getInputAccessIcon(form).hasClass("fa-toggle-on")) {
      toggleInputAndDelete(form);
    }
  });

  //compare with below
  $("body").on("show.bs.collapse", ".toggle-sibling", function(){
    var sib_id = $(this).attr("id");
    var label = $(this).attr("data-label");
    getLabel("#"+sib_id).text(label);
    $('a[href="#'+sib_id+'"]').prop("disabled", true).addClass("disabled").siblings().prop("disabled", false).removeClass("disabled");
    if (sib_id.includes("edit")) {
      getDeleteIcon("#"+sib_id).addClass("fa-times");
    } else {
      getDeleteIcon("#"+sib_id).removeClass("fa-times");
    }
  });

  //handler for submitting product_part form: on checkbox selection
  $("body").on("click", ".category-check", function(){
    var form = $(this).closest(".form");
    var check_box = $(form).find("input:checkbox.category");
    checkBoxSubmit(form, check_box);
  });

  $("body").on("click", ".display-check", function(){
    var form = $(this).closest(".form");
    var check_box = $(form).find("input:checkbox.display");
    checkBoxSubmit(form, check_box);
  });

  //handler for submitting search form: on dropdown selection
  $("body").on("change", ".search-select", function(){
    var form = $(this).closest(".form");
    $(form).submit();
  });

  //handler for enable/disable form with valid/present values
  $("body").on("change keyup", ".name-field, .type-field", function(){
    var form = $(this).closest(".form");
    enableSubmit(form);
  });

  $("body").on("click", ".select-opt", function(){
    var a = $(this);
    var form = $(a).closest(".form");
    //$(form).find("label.type-label").text($(a).attr("data-name"));
    $(form).find(".type-label").text($(a).attr("data-name"));
    $(form).find("input:text.type-field").val($(a).attr("data-value"));
    enableSubmit(form);
    $(a).addClass("active").siblings().removeClass("active");
  });

  $("body").on("click", ".reset-btn", function() {
    var form = $(this).closest(".form");
    var a = $(form).find("a:first");
    resetDropdown(form, a);
    enableSubmit(form);
  });

});

//named functions
function toggleDisable(input_set){
  $(input_set).each(function(i, input){
    if ($(input).attr("disabled") == "disabled") {
      $(input).attr("disabled", false);
    } else {
      $(input).attr("disabled", true);
    }
  });
}
function enableSubmit(form) {
  if ($(form).find(".name-field").val().length > 0 && $(form).find(".type-field").val().length > 0) {
    $(form).find("button:submit").prop("disabled", false);
  } else {
    $(form).find("button:submit").prop("disabled", true);
  }
}
function resetDropdown(form, a) {
  $(form).find(".type-label").text($(a).attr("data-name"));
  $(form).find("input:text").val($(a).attr("data-value"));
  $(a).addClass("active").siblings().removeClass("active");
}

function checkBoxSubmit(form, check_box) {
  if ($(check_box).prop("checked") == true){
    $(check_box).prop("checked", false);
  } else {
    $(check_box).prop("checked", true);
  }
  $(form).submit();
}

//combined functions
function toggleFormOnCreate(form) {
  if ($.inArray('edit', form.split('-')) == -1){
    var ref_sibling = getCurrentToggleSib(form);
    var ref_id = $(ref_sibling).attr("id");
    var target_id = getEditSib(ref_id).attr("id");
    getCurrentToggleSib(form).removeClass('show');
    //toggleSibForms(ref_sibling, ref_id);
    getEditSib(ref_id).addClass('show');
    showDisabledDeleteBtn(form);
    resetDropdownOptions(target_id);
    resetInputLabel(target_id);
    toggleCaretDownBodyShow(target_id);
  }
}
function configShow(form) {
  enableToggleInput(form);
  getCaret(form).prop("disabled", false).find("i").toggleClass("fa-caret-right fa-caret-down");
  getLabel(form).toggleClass("text-light text-muted");
  getDropdownBtn(form).removeClass("disabled").addClass("text-info").attr("href", "#");
  enableCustomInputs();
  getBody(form).toggleClass("show");
}
function toggleInputAndDelete(form) {
  toggleInputAccess(form);
  getDeleteBtn(form).toggleClass("disabled");
}
function toggleInputAccess(form) {
  getInputAccessIcon(form).toggleClass("fa-toggle-on fa-toggle-off");
  getInputGroupDiv(form).toggleClass("bg-white bg-disabled");
  getInputs(form).each(function(i, input){
    $(input).prop("disabled") == false ? $(input).prop("disabled", true) : $(input).prop("disabled", false)
  });
}

function toggleShowView(show_id, show_partial) {
  var id_arr = show_id.split('-');
  if ($(show_id).length == 0) {
    $(id_arr.splice(0,1).join(' ')).html(show_partial);
  } else {
    $(show_id).remove();
    id_arr.splice(2,1, 'tab-item');
    $(id_arr.join('-')).removeClass("active");
  }
}

// function removeShowView(show_id) {
//   var id_arr = show_id.split('-');
//   if ($(show_id).length > 0) {
//     $(show_id).remove();
//   }
// }
function refreshCreate(show_id, tab_item_partial, show_partial){
  var tab_index_id = show_id.concat('-', 'tab-index');
  $(tab_index_id).find('.list-group-item').removeClass("active");
  $(tab_index_id).append(tab_item_partial);
  $(show_id).html(show_partial);
}
//combo functions
function enableToggleInput(form) {
  getInputAccessBtn(form).prop("disabled", false);
}
function disableToggleInput(form) {
  getInputAccessBtn(form).prop("disabled", true);
}
// function enableNewInputs(form) {
//   $(form).find("input:text, button:submit").prop("disabled", false);
// }
function enableCustomInputs() {
  $("input:radio[value='custom']:checked").closest(".col").find("input:text").prop("disabled", false);
}
function resetInputLabel(target_id){
  var new_label = $("#"+target_id).attr("data-label");
  return getLabel("#"+target_id).text(new_label);
}
function resetDropdownOptions(id){
  return $('a[href="#'+id+'"]').prop("disabled", true).addClass("disabled").siblings().prop("disabled", false).removeClass("disabled");
}
function toggleInputAccessIcon(form) {
  return getInputAccessIcon(form).toggleClass("fa-toggle-on fa-toggle-off");
}
function toggleSibCarets(card){
  return $(card).siblings().find("i").hasClass("fa-caret-down").first().toggleClass("fa-caret-down fa-caret-right");
}
function toggleSibForms(ref_sibling, ref_id){
  //return $(ref_sibling).add(getEditSib(ref_id)).toggleClass("show");
  //return $(ref_sibling).removeClass("show");
  return $(ref_sibling).siblings().removeClass("show");
}
function toggleCaretDownBodyShow(target){
  var caret = getCaretIcon("#"+target);
  if ($(caret).hasClass("fa-caret-right")){
    $(caret).toggleClass("fa-caret-right fa-caret-down");
    toggleCardBody("#"+target);
  }
}
function toggleCardBody(target){
  getBody(target).toggleClass("show");
}
function showDisabledDeleteBtn(form){
  return getDeleteBtn(form).addClass("disabled").find("i").addClass("fa-times");
}
function addOption(form, id, name){
  $(form).find("option:last").after("<option value='"+id+"'>"+name+"</option>");
}
function removeOption(form, id){
  $(form).find("option[value='"+id+"']").hide();
}
//getter functions
//$(form).closest(".card-header").find(target) -> header functions: target == ".form" (usually)
function getHeader(target) {
  return $(target).closest(".card-header").first();
}
function getCaret(target) {
  return getHeader(target).find(".caret-toggle");
}
function getCaretIcon(target) {
  return getCaret(target).find("i");
}
function getLabel(target) {
  return getHeader(target).find(".input-label");
}
function getDropdownIcon(target) {
  getDropdownBtn(target).find("i");
}
function getDropdownBtn(target) {
  return getHeader(target).find(".nav-link").first();
  //return getHeader(target).find("a.nav-link.i.fa-ellipsis-v").first();
}
function getDeleteBtn(target) {
  return getHeader(target).find("a.delete-btn");
}
function getDeleteIcon(target) {
  return getDeleteBtn(target).find("i");
}
function getBody(target) {
  return getHeader(target).next(".card-body");
}
function getCard(target){
  return $(target).closest("div[id*='show']");
}
function getEditSib(id){
  return $("#"+id).siblings(".toggle-sibling[id$='edit']");
}
function getCurrentToggleSib(form){
  return $(form).closest(".toggle-sibling");
}
//form functions
function getInputAccessBtn(form) {
  return $(form).find(".toggle-input-access");
}
function getInputAccessIcon(form) {
  return getInputAccessBtn(form).find("i");
}

function getInputGroupDiv(form) {
  return $(form).find("div.input-group");
}
function getInputs(form) {
  return $(form).find("input:text, select, button:submit, button.category-check, button.display-check");
}
function getCheckInput(form) {
  return $(form).find("input:checkbox[name=category]").val();
}

// function getCategoryInput(form) {
//   return $(form).find("input:checkbox.category");
// }

// $("body").on("show.bs.collapse", "#artist-form", function(){
//   var form = $("#artist-show-form-id");
//   $(form).find(".input-group").toggleClass("bg-white bg-disabled");
//   $(form).find("select").prop("disabled", true);
// });

//   $("body").on("hide.bs.collapse", "#artist-form", function(){
//     var form = $("#artist-show-form-id");
//     $(form).find(".input-group").toggleClass("bg-white bg-disabled");
//     $(form).find("select").prop("disabled", false);
//   });
