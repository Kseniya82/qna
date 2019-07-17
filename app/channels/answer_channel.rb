class AnswerChannel < ApplicationCable::Channel
  def follow(data)
    stream_from "questions/#{data['question_id']}/answers"
  end

  def unfollow
    stop_all_streams
  end
end
