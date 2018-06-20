require_relative 'acceptance_helper'

feature 'Vote for answer', %q{
  In order to mark better answer
  As an authenticated user and non answer's author
  I want to be able to vote for answer
} do
  given(:author) { create(:user) }
  given(:user) { create(:user) }
  given(:question) { create(:question, user: author) }
  given!(:answer) { create(:answer, question: question, user: author) }

  scenario "Non authenticated user" do
    visit question_path(question)

    within ".answer-vote" do
      expect(page).to have_no_link "+"
      expect(page).to have_no_link "-"
      expect(page).to have_content answer.rating
    end
  end

  scenario "Answer author" do
    sign_in(author)
    visit question_path(question)

    within ".answer-vote" do
      expect(page).to have_no_link "+"
      expect(page).to have_no_link "-"
      expect(page).to have_content answer.rating
    end
  end

  scenario "Authenticated user", js: true do
    sign_in(user)
    visit question_path(question)

    within ".answer-vote" do
      click_on "+"
      expect(page).to have_content 1

      click_on "cancel vote"
      expect(page).to have_content 0

      click_on "-"
      expect(page).to have_content(-1)
    end
  end
end
