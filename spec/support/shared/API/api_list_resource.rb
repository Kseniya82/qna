shared_examples_for 'return list resource with public fields' do
  it 'returns list of resorce' do
    expect(list_resource_response.size).to eq resource_count
  end
  it_behaves_like 'return resource with public fields'
end

shared_examples_for 'return resource with public fields' do
  it 'returns all public fields' do
    fields.each do |attr|
      expect(resource_response[attr]).to eq resource.send(attr).as_json
    end
  end
end
