require 'rails_helper'

feature 'See list of all questions', %q{
  As a user
  I can see list of all questions
} do

  scenario 'User see questions' do
    visit questions_path

    expect(page).to have_css('ul.questions')
  end
end
