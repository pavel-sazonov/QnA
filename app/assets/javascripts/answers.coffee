# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

ready = ->
  $('.answers').on 'click', '.edit-answer-link', (e) ->
    e.preventDefault();
    $(this).hide();
    answer_id = $(this).data('answerId');
    $('form#edit-answer-' + answer_id).show();

  $('.vote-up-link, .vote-down-link, .vote-cancel-link').on 'ajax:success', (event) ->
    response_json = $.parseJSON(event.detail[2].responseText)
    $('.answer-rating-' + response_json.votable_id).html(response_json.rating + ' ')

$(document).ready(ready)
$(document).on('turbolinks:load', ready)
