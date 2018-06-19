# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

ready = ->
  $('.question').on 'click', '.edit-question-link', (e) ->
    e.preventDefault();
    $(this).hide();
    $('form.edit_question').show();

  $('.question .vote-up-link').on 'ajax:success', (event) ->
    raiting = $.parseJSON(event.detail[2].responseText)
    $('.question-raiting').html(raiting + ' ')

  $('.question .vote-down-link').on 'ajax:success', (event) ->
    raiting = $.parseJSON(event.detail[2].responseText)
    $('.question-raiting').html(raiting + ' ')

  $('.question .vote-cancel-link').on 'ajax:success', (event) ->
    raiting = $.parseJSON(event.detail[2].responseText)
    $('.question-raiting').html(raiting + ' ')

$(document).ready(ready)
$(document).on('turbolinks:load', ready)
