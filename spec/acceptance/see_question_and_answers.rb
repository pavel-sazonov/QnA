require 'rails_helper'

feature 'See question and answers', %q{
  As an user
  I want to be able to see question and answers the question
} do

  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given!(:answer) { create_list(:answer, 5, question: question, user: user) }

  scenario 'User can see question and answers the question' do
    visit(question_path(question))

    expect(page).to have_content 'TestQuestionTitle'
    expect(page).to have_content 'TestQuestionBody'
    (1..5).each { |n| expect(page).to have_content "TestAnswerBody-#{n}" }
  end
end
