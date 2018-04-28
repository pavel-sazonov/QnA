require 'rails_helper'

feature 'Create answer', %q{
  As a user
  I can answer the question
} do
  given(:question) { create(:question) }

  scenario 'User answer the question' do
    visit question_path(question)
    fill_in 'Body', with: 'some answer'
    click_on 'Create'

    expect(page).to have_content 'Your answer successfully created.'
    expect(page).to have_content 'some answer'
  end
end
