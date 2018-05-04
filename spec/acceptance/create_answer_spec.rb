require 'rails_helper'

feature 'Create answer', %q{
  As a user
  I can answer the question
  On the question page
} do

  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }

  scenario 'Authenticated user answer the question with valid attributes' do
    sign_in(user)

    visit question_path(question)
    fill_in 'Body', with: 'some answer'
    click_on 'Create'

    expect(page).to have_content 'Your answer successfully created.'
    expect(page).to have_content 'some answer'
  end

  scenario 'Authenticated user creates answer the question with invalid attributes' do
    sign_in(user)

    visit question_path(question)
    click_on 'Create'

    expect(page).to have_content 'Body can\'t be blank'
    expect(page).to have_content 'Body is too short (minimum is 5 characters)'
  end

  scenario 'Non-authenticated user tries to answer the question' do
    visit question_path(question)
    fill_in 'Body', with: 'some answer'
    click_on 'Create'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end
