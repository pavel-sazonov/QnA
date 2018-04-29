require 'rails_helper'

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
    click_on 'Delete question'

    expect(page).to have_content 'Question deleted.'
    expect(current_path).to eq questions_path
  end

  scenario 'Authenticate user tries to delete question he did not create' do
    sign_in(another_user)
    visit question_path(question)

    expect(page).to_not have_link 'Delete question'
  end

  scenario 'Non-authenticated user tries to delete question' do
    visit question_path(question)

    expect(page).to_not have_link 'Delete question'
  end
end
