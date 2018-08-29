require_relative 'acceptance_helper'

feature 'Search', %q(
  As an user
  I want to be able to search resources
) do
  given!(:question) { create :question, title: 'search-test' }
  given!(:answer) { create :answer, body: 'search-test' }

  scenario 'user searches in questions', js: true do
    ThinkingSphinx::Test.run do
      visit search_path
      fill_in 'q', with: 'search-test'
      select 'Question', from: 'model'
      click_button 'Search'

      within '.results' do
        expect(page).to have_content 'Question'
        expect(page).to have_content question.id
        expect(page).to_not have_content 'Answer'
      end
    end
  end

  scenario 'user searches in answers', js: true do
    ThinkingSphinx::Test.run do
      visit search_path
      fill_in 'q', with: 'search-test'
      select 'Answer', from: 'model'
      click_button 'Search'

      within '.results' do
        expect(page).to_not have_content 'Question'
        expect(page).to have_content 'Answer'
        expect(page).to have_content answer.id
      end
    end
  end

  scenario 'user searches everywhere', js: true do
    ThinkingSphinx::Test.run do
      visit search_path
      fill_in 'q', with: 'search-test'
      select 'Everywhere', from: 'model'
      click_button 'Search'

      within '.results' do
        expect(page).to have_content 'Question'
        expect(page).to have_content question.id
        expect(page).to have_content 'Answer'
        expect(page).to have_content answer.id
      end
    end
  end
end
