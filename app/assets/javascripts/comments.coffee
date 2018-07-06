ready = ->
  # appear new comment form
  $('.new-comment').on 'click', '.new-comment-link', (e) ->
    e.preventDefault();
    $(this).hide();
    commentableId = $(this).data('commentableId');
    $('form#new-comment-commentable-' + commentableId).show();

  # disappear new comment form
  $('.new-comment').on 'click', '.cancel-new-comment', (e) ->
    e.preventDefault();
    commentableId = $(this).data('commentableId');
    $('form#new-comment-commentable-' + commentableId).hide();
    $('.new-comment-link').show()

  # create comment
  $('form.new_comment').on 'ajax:success', (event) ->
    xhr = $.parseJSON(event.detail[2].responseText)
    errors = xhr.errors
    comment = xhr.comment

    if errors
      $('.errors').html(JST['templates/errors'](errors: errors))

    if comment
      commentType = if comment.commentable_type == 'Question' then '.question-comments' else ('#comments-answer-' + comment.commentable_id)
      $(commentType).append(JST['templates/comment'](comment: comment))
      $('#comment_body_create').val('')
      $('form.new_comment').hide()
      $('.new-comment-link').show()

  # delete comment
  $('.delete-comment-link').on 'ajax:success', (event) ->
    received_data = $.parseJSON(event.detail[2].responseText)
    $('#comment-' + received_data.comment_id).remove()


  App.cable.subscriptions.create('CommentsChannel', {
    connected: ->
      @perform 'follow', question_id: gon.question_id

    received: (data) ->
      # без условия комментарий рендерится 2 раза на странице, на которой он создается
      if data.comment.user_id != gon.user_id
        commentType = if data.comment.commentable_type == 'Question' then '.question-comments' else ('#comments-answer-' + data.comment.commentable_id)
        $(commentType).append(JST['templates/comment'](
          comment: data.comment
        ))
  })

# с этой опцией комментарий или другой ресурс рендерится 4 раза в другом окне
# $(document).ready(ready)
$(document).on('turbolinks:load', ready)
