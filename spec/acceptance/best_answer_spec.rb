require_relative 'acceptance_helper'

feature 'Choose best answer', %q{
  As a author of the question
  I'd like to be able to choose best answer
} do

  given(:question_author) { create(:user) }
  given(:user) { create(:user) }
  given(:question) { create(:question, user: question_author) }
  given!(:answer) { create(:answer, question: question, user: user) }
  given!(:another_answer) { create(:answer, question: question, user: user) }

  scenario 'Author of question chooses best answer', js: true do
    sign_in question_author
    visit question_path(question)

    within "#answer_#{answer.id}" do
      click_on 'Set best answer'
    end

    within '.answers li:first-child' do
      expect(page).to have_content 'The best answer'
      expect(page).to have_content answer.body
    end

    within "#answer_#{another_answer.id}" do
      click_on 'Set best answer'
    end

    within '.answers li:first-child' do
      expect(page).to have_content 'The best answer'
      expect(page).to have_content another_answer.body
      expect(page).to have_no_link 'Set best answer'
    end
  end

  scenario 'Non-author of question does not see best answer link' do
    sign_in user
    visit question_path(question)

    expect(page).to have_no_link 'Set best answer'
  end

  scenario 'Unauthenticated user does not see best answer link' do
    visit question_path(question)

    expect(page).to have_no_link 'Set best answer'
  end
end
