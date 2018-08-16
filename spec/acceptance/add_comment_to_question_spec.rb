require_relative 'acceptance_helper'

feature 'Add comment to question', %q(
  As an authorized user
  I want to be able to comment question
) do
  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }

  scenario "authenticated user tries to create comment", js: true do
    sign_in(user)
    visit question_path(question)

    within '.question' do
      click_on 'add comment'
      fill_in 'Your comment', with: 'comment-example'
      click_on 'Create'

      expect(page).to have_content 'comment-example'
      expect(page).to have_link 'delete', href: %r{/comments/\d+}
    end
  end

  scenario "authenticated user tries to create comment with invalid attributes", js: true do
    sign_in(user)
    visit question_path(question)

    within '.question' do
      click_on 'add comment'
      fill_in 'Your comment', with: ''
      click_on 'Create'
    end

    expect(page).to have_content "can%27t%20be%20blank"
    expect(page).to have_content "is%20too%20short%20%28minimum%20is%205%20characters%29"
  end

  scenario "non authenticated user tries to create comment" do
    visit question_path(question)
    within '.question' do
      expect(page).to_not have_link 'add comment'
    end
  end

  scenario "comment appears on another user's page", js: true do
    Capybara.using_session('user') do
      sign_in(user)
      visit question_path(question)
    end

    Capybara.using_session('guest') do
      visit question_path(question)
    end

    Capybara.using_session('user') do
      within '.question' do
        click_on 'add comment'
        fill_in 'Your comment', with: 'comment'
        click_on 'Create'
      end
    end

    Capybara.using_session('guest') do
      within '.question' do
        expect(page).to have_content 'comment'
      end
    end
  end
end
