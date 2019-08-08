class QuestionSerializer < ActiveModel::Serializer
  attributes :id, :body, :title, :created_at, :updated_at, :user_id
end
