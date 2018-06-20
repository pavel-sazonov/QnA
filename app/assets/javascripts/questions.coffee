# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

ready = ->
  $('.question').on 'click', '.edit-question-link', (e) ->
    e.preventDefault();
    $(this).hide();
    $('form.edit_question').show();

  $('.question-vote').on 'ajax:success', (event) ->
    response_json = $.parseJSON(event.detail[2].responseText)
    $('.question-rating').html(response_json.rating + ' ')

$(document).ready(ready)
$(document).on('turbolinks:load', ready)
