# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

ready = ->
  $('.answers').on 'click', '.edit-answer-link', (e) ->
    e.preventDefault();
    $(this).hide();
    answer_id = $(this).data('answerId');
    $('form#edit-answer-' + answer_id).show();

  $('.answers .vote-up-link').on 'ajax:success', (event) ->
    answer_id = $(this).data('answerId')
    raiting = $.parseJSON(event.detail[2].responseText)
    $('.answer-raiting-' + answer_id).html(raiting + ' ')

  $('.answers .vote-down-link').on 'ajax:success', (event) ->
    answer_id = $(this).data('answerId')
    raiting = $.parseJSON(event.detail[2].responseText)
    $('.answer-raiting-' + answer_id).html(raiting + ' ')

  $('.answers .vote-cancel-link').on 'ajax:success', (event) ->
    answer_id = $(this).data('answerId')
    raiting = $.parseJSON(event.detail[2].responseText)
    $('.answer-raiting-' + answer_id).html(raiting + ' ')

$(document).ready(ready)
$(document).on('turbolinks:load', ready)
