require_relative 'acceptance_helper'

feature 'Choose best answer', %q{
  As a author of the question
  I'd like to be able to choose best answer
} do

  given(:author) { create(:user) }
  given(:user) { create(:user) }
  given(:question) { create(:question, user: author) }
  given!(:answer) { create(:answer, question: question, user: author) }
  given!(:another_answer) { create(:answer, question: question, user: user) }

  describe 'Author of question' do
    before do
      sign_in author
      visit question_path(question)
    end

    scenario "sees 'Set best answer' link" do
      expect(page).to have_link 'Set best answer'
    end

    scenario 'chooses best answer', js: true do
      within "#answer_#{answer.id}" do
        click_on 'Set best answer'
        expect(page).to have_content 'The best answer'
      end
    end

    scenario 'The best answer become first of the answer\'s list'
  end

  scenario 'Non-author of question does not see best answer link' do
    sign_in user

    expect(page).to_not have_link 'Set best answer'
  end

  scenario 'Unauthenticated user does not see best answer link' do
    expect(page).to_not have_link 'Best answer'
  end
end
