require 'rails_helper'

RSpec.describe NewAnswerJob, type: :job do
  let(:answer) { create(:answer) }
  it 'call new answer job' do
    NewAnswerJob.perform_now(answer)
  end

end
