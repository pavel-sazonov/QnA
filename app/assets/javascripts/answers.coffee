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

  $('form.edit_answer').submit 'ajax:error', (event) ->
    $('.errors').html('Unable to manage this answer')

  $('.delete-answer-link, .best-answer-link').on 'ajax:error', (event) ->
    $('.errors').html('Unable to manage this answer')


  $('.vote-up-link, .vote-down-link').on 'ajax:success', (event) ->
    response_json = $.parseJSON(event.detail[2].responseText)
    $('#answer-rating-' + response_json.votable_id).html(response_json.rating)
    $('#answer-vote-links-' + response_json.votable_id).html('')
    $('#answer-vote-links-' + response_json.votable_id).html('<a class="vote-cancel-link" data-type="json" data-remote="true" rel="nofollow" data-method="delete" href="/answers/' + response_json.votable_id + '/cancel_vote">cancel</a>')

  .on 'ajax:error', (event) ->
    response_json = $.parseJSON(event.detail[2].responseText)
    $('.errors').html(response_json.errors)

  # если ссылка создана динамически, то по ней почему-то не срабатывает этот код
  $('.vote-cancel-link').on 'ajax:success', (event) ->
    response_json = $.parseJSON(event.detail[2].responseText)
    $('#answer-rating-' + response_json.votable_id).html(response_json.rating)
    $('#answer-vote-links-' + response_json.votable_id).html('')
    $('#answer-vote-links-' + response_json.votable_id).html('<a class="vote-up-link" data-type="json" data-remote="true" rel="nofollow" data-method="post" href="/answers/' + response_json.votable_id + '/vote_up">+</a>' + ' ')
    $('#answer-vote-links-' + response_json.votable_id).append('<a class="vote-down-link" data-type="json" data-remote="true" rel="nofollow" data-method="post" href="/answers/' + response_json.votable_id + '/vote_down">-</a>')

  .on 'ajax:error', (event) ->
    response_json = $.parseJSON(event.detail[2].responseText)
    $('.errors').html(response_json.errors)


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
