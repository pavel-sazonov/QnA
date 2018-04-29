require 'rails_helper'

feature 'Create answer', %q{
  As a user
  I can answer the question
} do

  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }

  scenario 'Authenticated user answer the question' do
    sign_in(user)

    visit question_path(question)
    fill_in 'Body', with: 'some answer'
    click_on 'Create'

    expect(page).to have_content 'Your answer successfully created.'
    expect(page).to have_content 'some answer'
  end

  scenario 'Non-authenticated user tries to answer the question' do
    visit question_path(question)
    fill_in 'Body', with: 'some answer'
    click_on 'Create'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end
