App.comment = App.cable.subscriptions.create "CommentChannel",
 connected: ->
    questionId = $('h1').data('question-id')
    @perform 'follow', question_id: questionId
  disconnected: ->
    @perform 'unfollow'
  received: (data) ->
    commentElement = $('comment-'+ data.resource + '-' + data.resource_id)
    commentElement.append JST['templates/comment'](
      id: data.id
      body: data.body
      )
