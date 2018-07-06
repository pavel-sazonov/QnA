# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

ready = ->
  $('.answers').on 'click', '.edit-answer-link', (e) ->
    e.preventDefault();
    $(this).hide();
    answer_id = $(this).data('answerId');
    $('form#edit-answer-' + answer_id).show();

  $('.answers').on 'click', '.cancel-edit', (e) ->
    e.preventDefault();
    answer_id = $(this).data('answerId');
    $('form#edit-answer-' + answer_id).hide();
    $('.edit-answer-link').show()

  $('.vote-up-link, .vote-down-link, .vote-cancel-link').on 'ajax:success', (event) ->
    response_json = $.parseJSON(event.detail[2].responseText)
    $('#answer-rating-' + response_json.votable_id).html(response_json.rating + ' ')

  App.cable.subscriptions.create('AnswersChannel', {
    connected: ->
      @perform 'follow', question_id: gon.question_id

    received: (data) ->
      if data.answer.user_id != gon.user_id
        $('.answers').append(JST['templates/answer'](
          answer: data.answer,
          attachments: data.attachments,
          rating: data.rating,
          questionUserId: data.question_user_id
        ))
  })

# $(document).ready(ready)
$(document).on('turbolinks:load', ready)
