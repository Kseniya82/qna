shared_examples_for 'updated resource' do
  it 'change public fields' do
    fields.each do |attr|
      expect(resource_response[attr]).to eq request_params[attr.to_sym]
    end
  end
end

shared_examples_for 'try update resource with invalid params' do
  before do
    do_request(method, api_path, params: request_params, headers: headers)
  end

  it 'returns :unprocessable_entity status' do
    expect(response.status).to eq 422
  end

  it 'returns error message' do
    expect(json['errors']).to be_truthy
  end
end
