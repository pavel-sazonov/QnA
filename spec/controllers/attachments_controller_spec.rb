require 'rails_helper'

RSpec.describe AttachmentsController, type: :controller do
  let(:user) { create(:user) }
  let(:another_user) { create(:user) }
  let(:question) { create(:question, user: user) }
  let!(:attachment) { create(:attachment, attachable: question) }

  describe 'DELETE #destroy' do
    context 'Author of question tries delete attachment' do
      before { sign_in(user) }

      it 'deletes attachment' do
        expect { delete :destroy, params: { id: attachment, format: :js } }
          .to change(question.attachments, :count).by(-1)
      end

      it 'render updated template' do
        delete :destroy, params: { id: attachment, format: :js }
        expect(response).to render_template :destroy
      end
    end

    context 'Non-author tries delete answer' do
      before { sign_in(another_user) }

      it 'does not delete answer' do
        expect { delete :destroy, params: { id: attachment, format: :js } }
          .to_not change(question.attachments, :count)
      end

      it 'render updated template' do
        delete :destroy, params: { id: attachment, format: :js }
        expect(response).to render_template :destroy
      end
    end
  end
end
