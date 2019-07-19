class CommentChannel < ApplicationCable::Channel
  def follow(data)
    stream_from "questions/#{data['question_id']}/comments"
  end

  def unfollow
    stop_all_streams
  end
end
