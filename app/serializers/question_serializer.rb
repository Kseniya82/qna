class QuestionSerializer < QuestionCollectionSerializer
  # attributes :id, :body, :title, :created_at, :updated_at, :user_id
  include Rails.application.routes.url_helpers

  has_many :comments
  has_many :links
  attributes :files

  def files
    return unless object.files.attachments
    file_urls = object.files.map do |file|
      rails_blob_path(file, only_path: true)
    end
    file_urls
  end
end
