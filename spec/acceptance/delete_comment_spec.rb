require_relative 'acceptance_helper'

feature 'Add comment to question/answer', %q(
  As an authorized user
  I want to be able to comment question
) do
  given(:author) { create(:user) }
  given(:user) { create(:user) }
  given(:question) { create(:question, user: author) }
  given!(:comment) { create(:comment, commentable: question, user: author) }

  scenario "comment's author tries to delete comment", js: true do
    sign_in author
    visit question_path(question)

    within "#comment-#{comment.id}" do
      click_on 'delete'
    end

    expect(page).to_not have_content comment.body
  end

  scenario "user tries to delete comment" do
    sign_in user
    visit question_path(question)

    within "#comment-#{comment.id}" do
      expect(page).to_not have_link "delete"
    end
  end

  scenario "guest tries to delete comment" do
    visit question_path(question)

    within "#comment-#{comment.id}" do
      expect(page).to_not have_link "delete"
    end
  end
end
