App.questions = App.cable.subscriptions.create "QuestionsChannel",
  connected: ->
    # Called when the subscription is ready for use on the server
    @perform 'follow'

  disconnected: ->
    @perform 'unfollow'

  received: (data) ->
    # Called when there's incoming data on the websocket for this channel
    $('.questions-list').append data
