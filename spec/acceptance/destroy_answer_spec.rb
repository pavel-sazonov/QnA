require 'rails_helper'

feature 'Delete answer', %q{
  As a authenticate user
  I want be able to delete my answer
} do

  given(:user) { create(:user) }
  given(:another_user) { create(:user) }
  given(:question) { create(:question, user: user) }

  scenario 'Authenticate user tries to delete answer he created' do
    sign_in(user)
    visit question_path(question)
    click_on 'Delete answer'

    expect(page).to have_content 'Answer deleted.'
    expect(current_path).to eq question_path(question)
  end

  scenario 'Authenticate user tries to delete answer he did not create' do
    sign_in(another_user)
    visit question_path(question)

    expect(page).to_not have_link 'Delete answer'
  end

  scenario 'Non-authenticated user tries to delete answer' do
    visit question_path(question)

    expect(page).to_not have_link 'Delete answer'
  end
end
