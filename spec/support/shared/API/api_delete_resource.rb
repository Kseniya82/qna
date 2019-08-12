shared_examples_for 'delete resource' do
  before do
    do_request(method, api_path, params: request_params, headers: headers)
  end

  it 'return empty response body' do
    expect(response.body).to eq '{}'
  end

  it 'does delete a resource from the database' do
    expect(resource.count).to eq 0
  end
end
