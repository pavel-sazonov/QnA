require_relative 'acceptance_helper'

feature "Delete question's attachment", %q{
  As a authenticate user
  I want be able to delete attachment of my question
} do

  given(:user) { create(:user) }
  given(:another_user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given!(:attachment) { create(:attachment, attachable: question) }

  scenario 'Authenticate user tries to delete attachment of his question', js: true do
    sign_in user
    visit question_path(question)

    click_on 'Delete attachment'

    expect(current_path).to eq question_path(question)
    expect(page).to have_no_link 'rails_helper.rb'
  end

  scenario 'Authenticate user tries to delete attachment of not his question' do
    sign_in(another_user)
    visit question_path(question)

    expect(page).to have_no_link 'Delete attachment'
  end

  scenario 'Non-authenticated user tries to delete question attachment' do
    visit question_path(question)

    expect(page).to have_no_link 'Delete attachment'
  end
end
