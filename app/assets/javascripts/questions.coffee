# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

ready = ->
  questionsList = $('.questions-list')

  $('.question').on 'click', '.edit-question-link', (e) ->
    e.preventDefault();
    $(this).hide();
    $('form.edit_question').show();

  $('.question-vote').on 'ajax:success', (event) ->
    response_json = $.parseJSON(event.detail[2].responseText)
    $('.question-rating').html(response_json.rating + ' ')
    $('#question-vote-links-' + response_json.votable_id).html('')
    $('#question-vote-links-' + response_json.votable_id).html('<a class="vote-cancel-link" data-type="json" data-remote="true" rel="nofollow" data-method="delete" href="/questions/' + response_json.votable_id + '/cancel_vote">cancel</a>')

  .on 'ajax:error', (event) ->
    response_json = $.parseJSON(event.detail[2].responseText)
    $('.errors').html(response_json.errors)

  $('.vote-cancel-link').on 'ajax:success', (event) ->
    response_json = $.parseJSON(event.detail[2].responseText)
    $('#answer-rating-' + response_json.votable_id).html(response_json.rating)
    # дальше код не работает почему-то
    $('#answer-vote-links-' + response_json.votable_id).html('')
    $('#answer-vote-links-' + response_json.votable_id).html('<a class="vote-up-link" data-type="json" data-remote="true" rel="nofollow" data-method="post" href="/answers/' + response_json.votable_id + '/vote_up">+</a>' + ' ')
    $('#answer-vote-links-' + response_json.votable_id).append('<a class="vote-down-link" data-type="json" data-remote="true" rel="nofollow" data-method="post" href="/answers/' + response_json.votable_id + '/vote_down">-</a>')

  .on 'ajax:error', (event) ->
    response_json = $.parseJSON(event.detail[2].responseText)
    $('.errors').html(response_json.errors)

  App.cable.subscriptions.create('QuestionsChannel', {
  connected: ->
    @perform 'follow'

  received: (data) ->
    questionsList.append data
  })


# $(document).ready(ready)
$(document).on('turbolinks:load', ready)
