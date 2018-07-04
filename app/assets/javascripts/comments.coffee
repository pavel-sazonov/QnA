ready = ->
  $('.new-comment').on 'click', '.new-comment-link', (e) ->
    e.preventDefault();
    $(this).hide();
    commentableId = $(this).data('commentableId');
    $('form#new-comment-commentable-' + commentableId).show();

  $('.new-comment').on 'click', '.cancel-new-comment', (e) ->
    e.preventDefault();
    commentableId = $(this).data('commentableId');
    $('form#new-comment-commentable-' + commentableId).hide();
    $('.new-comment-link').show()

  $('form.new_comment').on 'ajax:success', (event) ->
    response_json = $.parseJSON(event.detail[2].responseText)
    commentable = response_json.commentable_class_name
    $('.comments-' + commentable).append(JST['templates/comment'](
      commentId: response_json.comment_id,
      commentBody: response_json.comment_body
      ))
    $('form.new_comment').hide()
    $('.new-comment-link').show()

  $('.delete-comment-link').on 'ajax:success', (event) ->
    response_json = $.parseJSON(event.detail[2].responseText)
    $('#comment-' + response_json.comment_id).remove()

# $(document).ready(ready)
$(document).on('turbolinks:load', ready)
