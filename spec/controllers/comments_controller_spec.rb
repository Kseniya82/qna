require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  let(:question) { create(:question, user: user) }
  let(:user) { create(:user) }
  describe 'POST #create' do
    before { login(user) }
    let!(:question) { create(:question, user: user) }
    let!(:answer) { create(:answer, user: user, question: question) }

    context 'question' do
      context 'with valid attributes' do
        it 'saves a new comment in the database' do
          expect { post :create, params: { comment: attributes_for(:comment), question_id: question }, format: :js }.to change(question.comments, :count).by(1)
        end

        it 'receives json response' do
          post :create, params: { comment: attributes_for(:comment), question_id: question }, format: :js
          json_response = { "resource" => 'question',
                            "resource_id" => question.id,
                            'id' => Comment.last.id,
                            "author_id" => user.id,
                            "body" => Comment.last.body}
          expect(response).to have_http_status :ok
          expect(JSON.parse(response.body)).to eq json_response
        end

        it 'saves a new user answer in the database' do
          expect { post :create, params: { comment: attributes_for(:comment), question_id: question }, format: :js }.to change(user.comments, :count).by(1)
        end
      end
      context 'with invalid attributes' do
        it 'doesn\'t save the comment' do
          expect { post :create, params: { comment: attributes_for(:comment, :invalid), question_id: question }, format: :js }.to_not change(Comment, :count)
        end

        it 'receives 422 response code' do
          post :create, params: { comment: attributes_for(:comment, :invalid), question_id: question }, format: :js
          expect(response.status).to eq(422)
        end
      end
    end

    context 'answer' do
      context 'with valid attributes' do
        it 'saves a new comment in the database' do
          expect { post :create, params: { comment: attributes_for(:comment), answer_id: answer }, format: :js }.to change(answer.comments, :count).by(1)
        end

        it 'receives json response' do
          post :create, params: { comment: attributes_for(:comment), answer_id: answer }, format: :js
          json_response = { "resource" => 'answer',
                            "resource_id" => answer.id,
                            'id' => Comment.last.id,
                            "author_id" => user.id,
                            "body" => Comment.last.body}

          expect(response).to have_http_status :ok
          expect(JSON.parse(response.body)).to eq json_response
        end

        it 'saves a new user answer in the database' do
          expect { post :create, params: { comment: attributes_for(:comment), answer_id: answer }, format: :js }.to change(user.comments, :count).by(1)
        end
      end
      context 'with invalid attributes' do
        it 'doesn\'t save the comment' do
          expect { post :create, params: { comment: attributes_for(:comment, :invalid), answer_id: answer }, format: :js }.to_not change(Comment, :count)
        end

        it 'receives 422 response code' do
          post :create, params: { comment: attributes_for(:comment, :invalid), answer_id: answer }, format: :js
          expect(response.status).to eq(422)
        end
      end
    end
  end
end
