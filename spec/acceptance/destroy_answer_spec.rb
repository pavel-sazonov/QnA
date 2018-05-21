require_relative 'acceptance_helper'

feature 'Delete answer', %q{
  As a authenticate user
  I want be able to delete my answer
} do

  given(:user) { create(:user) }
  given(:another_user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question, user: user) }

  scenario 'Authenticate user tries to delete answer he created', js: true do
    sign_in(user)
    visit question_path(question)
    within '.answers' do
      expect(page).to have_link 'Delete'
      click_on 'Delete'
    end

    expect(current_path).to eq question_path(question)
    expect(page).to_not have_content answer.body
  end

  scenario 'Authenticate user tries to delete answer he did not create' do
    sign_in(another_user)
    visit question_path(question)

    within '.answers' do
      expect(page).to_not have_link 'Delete'
    end
  end

  scenario 'Non-authenticated user tries to delete answer' do
    visit question_path(question)

    within '.answers' do
      expect(page).to_not have_link 'Delete'
    end
  end
end
