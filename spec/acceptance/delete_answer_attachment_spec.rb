require_relative 'acceptance_helper'

feature "Delete answer's attachment", %q{
  As a authenticate user
  I want be able to delete attachment of my answer
} do

  given(:user) { create(:user) }
  given(:another_user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given(:answer) { create(:answer, question: question, user: user) }
  given!(:attachment) { create(:attachment, attachable: answer) }

  scenario 'Authenticate user tries to delete attachment of his answer', js: true do
    sign_in user
    visit question_path(question)

    within '.answers' do
      click_on 'Delete attachment'
      expect(page).to have_no_link 'rails_helper.rb'
    end

    expect(current_path).to eq question_path(question)
  end

  scenario 'Authenticate user tries to delete attachment of not his answer' do
    sign_in(another_user)
    visit question_path(question)
    within '.answers' do
      expect(page).to have_no_link 'Delete attachment'
    end
  end

  scenario 'Non-authenticated user tries to delete answer attachment' do
    visit question_path(question)

    within '.answers' do
      expect(page).to have_no_link 'Delete attachment'
    end
  end
end
