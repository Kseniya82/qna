shared_examples_for 'created resource' do
  it_behaves_like 'updated resource'
  it 'save a new resource in database' do
    expect(resource.count).to eq 1
  end

  it 'return me as author question' do
    expect(resource_response['user_id']).to eq me.id
  end
end

shared_examples_for 'try created resource with invalid params' do
  it_behaves_like 'try update resource with invalid params'
  it 'does not saves a new resource in the database' do
    expect(resource.count).to eq 0
  end
end
