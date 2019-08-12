shared_examples_for 'DELETE #destroy' do
  context 'Author tried delete resource' do
    it 'deletes the resource from  database' do
      expect { delete :destroy, params: { id: own_resource}, format: :js }.to change(klass_resource, :count).by(-1)
    end

    it 'renders destroy view' do
      delete :destroy, params:  { id: own_resource }, format: :js
      expect(response).to render_template :destroy
    end
  end

  context ' Not author tried delete resource' do
    it 'no deletes the resource' do
      expect { delete :destroy, params: { id: resource }, format: :js }.to_not change(klass_resource, :count)
    end

    it 'redirects to root path' do
      delete :destroy, params: { id: resource }
      expect(response).to redirect_to root_path
    end
  end
end
