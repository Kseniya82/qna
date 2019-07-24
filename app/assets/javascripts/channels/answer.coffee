App.answer = App.cable.subscriptions.create "AnswerChannel",
 connected: ->
    questionId = $('#question').data('question-id')
    @perform 'follow', question_id: questionId
  disconnected: ->
    @perform 'unfollow'
  received: (data) ->

    if data.author_id != gon.user_id
      $('.answers').append JST['templates/answer'](
        answer: data.answer
        links: data.links
        files: data.files)
    return
