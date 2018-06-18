require_relative 'acceptance_helper'

feature 'Vote for question', %q{
  In order to mark better question
  As an authenticated user and non question's author
  I want to be able to vote for question
} do
  given(:author) { create(:user) }
  given(:user) { create(:user) }
  given(:question) { create(:question, user: author) }

  background do

  end

  scenario "Non authenticated user tries to vote for question" do
    visit question_path(question)

    within ".question" do
      expect(page).to have_no_link "+"
      expect(page).to have_no_link "-"
    end
  end

  scenario "Question author tries to vote for his question" do
    sign_in(author)
    visit question_path(question)

    within ".question" do
      expect(page).to have_no_link "+"
      expect(page).to have_no_link "-"
    end
  end

  scenario "Authenticated user tries to vote for question", js: true do
    sign_in(user)
    visit question_path(question)

    within ".question-raiting" do
      click_on "+"
      expect(page).to have_content question.vote_result
    end
  end
end
