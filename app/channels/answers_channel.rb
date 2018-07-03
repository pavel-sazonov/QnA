class AnswersChannel < ApplicationCable::Channel
  def follow(data)
    stream_from "answers for question id: #{data['question_id']}"
  end
end
