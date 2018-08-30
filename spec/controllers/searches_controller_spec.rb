require 'rails_helper'

RSpec.describe SearchesController, type: :controller do
  describe 'GET #show' do
    it 'show search page' do
      get :show
      expect(response).to render_template :show
    end
  end

  describe 'GET #result' do
    it 'send method search to model' do
      expect(Answer).to receive(:search).with('test', per_page: 20, order: 'created_at DESC')
      get :result, params: { q: 'test', model: 'Answer'}, xhr: true
    end

    context 'query is empty' do
      it 're-render show view' do
        get :result, params: { q: '', model: 'Answer'}, xhr: true
        expect(response).to render_template :show
      end
    end
  end
end
