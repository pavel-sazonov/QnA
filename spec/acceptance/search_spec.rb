require_relative 'acceptance_helper'

feature 'Search', %q(
  As an user
  I want to be able to search resources
) do
  given!(:user) { create :user, email: 'search-user@test.com' }
  given!(:question) { create :question, title: 'search-question' }
  given!(:answer) { create :answer, body: 'search-answer' }

  scenario 'user searches', js: true do
    ThinkingSphinx::Test.run do
      visit search_path
      fill_in 'q', with: 'search-question'
      select 'Question', from: 'model'
      click_button 'Search'

      expect(page).to have_link question.title
      expect(page).to_not have_content answer.body

      fill_in 'q', with: 'search-answer'
      select 'Answer', from: 'model'
      click_button 'Search'

      expect(page).to_not have_link question.title
      expect(page).to have_content answer.body

      fill_in 'q', with: 'search-user'
      select 'User', from: 'model'
      click_button 'Search'

      expect(page).to_not have_link question.title
      expect(page).to have_content user.email

      fill_in 'q', with: 'search'
      select 'Everywhere', from: 'model'
      click_button 'Search'

      expect(page).to have_link question.title
      expect(page).to have_content user.email
      expect(page).to have_content answer.body
    end
  end
end
