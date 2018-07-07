require_relative 'acceptance_helper'

feature 'See list of all questions', %q{
  As a user
  I can see list of all questions
} do

  given(:user) { create(:user) }
  given!(:questions) { create_list(:question, 5, user: user) }

  scenario 'User see questions' do
    visit questions_path

    questions.each do |question|
      expect(page).to have_content question.title
    end
  end
end
