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
  $("#category-new").find("input:text, button:submit").prop("disabled", false);

  $("body").on("click", ".caret-toggle", function(){
    $(this).find("i").toggleClass("fa-caret-right fa-caret-down");
  });

  $("body").on("click", ".toggle-input-access", function(){
    var form = $(this).closest(".form");
    toggleInputAndDelete(form);
  });

  $("body").on("click", ".submit-btn", function(){
    var form = $(this).closest(".form");
    toggleInputAndDelete(form);
  });

  $("body").on("hidden.bs.collapse", ".toggle-sibling", function(){
    var form = $(this).find(".form");
    if (getInputAccessIcon(form).hasClass("fa-toggle-on")) {
      toggleInputAndDelete(form);
    }
  });

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
});

//combined functions
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

//binary #1
function enableToggleInput(form) {
  getInputAccessBtn(form).prop("disabled", false);
}
function disableToggleInput(form) {
  getInputAccessBtn(form).prop("disabled", true);
}

//header functions: target == ".form" (usually)
//$(form).closest(".card-header").find(target)
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
function getDeleteBtn(target) {
  return getHeader(target).find("a.delete-btn");
}
function getDeleteIcon(target) {
  return getDeleteBtn(target).find("i");
}
function getDropdownBtn(target) {
  return getHeader(target).find(".nav-link").first();
}
function getBody(target) {
  return getHeader(target).next(".card-body");
}

//form functions
function getInputAccessBtn(form) {
  return $(form).find(".toggle-input-access");
}
function getInputAccessIcon(form) {
  return getInputAccessBtn(form).find("i");
}
function toggleInputAccessIcon(form) {
  return getInputAccessIcon(form).toggleClass("fa-toggle-on fa-toggle-off");
}
function getInputGroupDiv(form) {
  return $(form).find("div.input-group");
}
function getInputs(form) {
  return $(form).find("input:text, select, button:submit");
}
function enableCustomInputs() {
  $("input:radio[value='custom']:checked").closest(".col").find("input:text").prop("disabled", false);
}
