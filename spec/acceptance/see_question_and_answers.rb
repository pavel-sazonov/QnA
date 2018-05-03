require 'rails_helper'

feature 'See question and answers', %q{
  As an user
  I want to be able to see question and answers on it
} do

  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question, user: user) }

  scenario 'User can see question and answers on it' do
    visit(question_path(question))

    expect(page).to have_content 'TestQuestionTitle'
    expect(page).to have_content 'TestQuestionBody'
    expect(page).to have_content 'TestAnswerBody'
  end
end
