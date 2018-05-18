require_relative 'acceptance_helper'

feature 'Delete question', %q{
  As a authenticate user
  I want be able to delete my question
} do

  given(:user) { create(:user) }
  given(:another_user) { create(:user) }
  given(:question) { create(:question, user: user) }

  scenario 'Authenticate user tries to delete question he created' do
    sign_in(user)
    visit question_path(question)
    within '.question' do
      expect(page).to have_link 'Delete'
      click_on 'Delete'
    end

    expect(page).to have_content 'Question deleted.'
    expect(current_path).to eq questions_path
    expect(current_path).to_not have_content question.body
  end

  scenario 'Authenticate user tries to delete question he did not create' do
    sign_in(another_user)
    visit question_path(question)

    within '.question' do
      expect(page).to_not have_link 'Delete'
    end
  end

  scenario 'Non-authenticated user tries to delete question' do
    visit question_path(question)

    within '.question' do
      expect(page).to_not have_link 'Delete'
    end
  end
end
