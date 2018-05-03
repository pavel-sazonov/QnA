require 'rails_helper'

feature 'See list of all questions', %q{
  As a user
  I can see list of all questions
} do

  given(:user) { create(:user) }
  given(:question) { create_list(:question, 5, user: user) }

  scenario 'User see questions' do
    visit questions_path

    user.questions.each do |question|
      expect(page).to have_content question.title
      expect(page).to have_content question.body
    end
  end
end
