require_relative 'acceptance_helper'

feature 'Create answer', %q{
  As a user
  I can answer the question
  On the question page
} do

  given(:user) { create(:user) }
  given(:another_user) { create(:user) }
  given(:question) { create(:question, user: user) }

  scenario 'Authenticated user answers the question with valid attributes', js: true do
    sign_in(user)

    visit question_path(question)
    fill_in 'Your answer', with: 'some answer'
    click_on 'Create'

    expect(current_path).to eq question_path(question)

    within '.answers' do
      expect(page).to have_content 'some answer'
    end
  end

  scenario 'Authenticated user tries to answer the question with invalid attributes', js: true do
    sign_in(user)

    visit question_path(question)
    click_on 'Create'

    expect(page).to have_content 'Body can\'t be blank'
    expect(page).to have_content 'Body is too short (minimum is 5 characters)'
  end

  scenario 'Non-authenticated user tries to answer the question' do
    visit question_path(question)

    expect(page).to have_content 'You must Login or Register to answer the question'
  end

  context "multiple sessions" do
    scenario "answer appears on another user's page", js: true do
      Capybara.using_session('user') do
        sign_in(user)
        visit question_path(question)
      end

      Capybara.using_session('another_user') do
        sign_in(another_user)
        visit question_path(question)
      end

      Capybara.using_session('user') do
        fill_in 'Your answer', with: 'some answer'
        click_on 'Create'

        within '.answers' do
          expect(page).to have_content 'some answer'
        end
      end

      Capybara.using_session('another_user') do
        within '.answers' do
          expect(page).to have_content 'some answer'
          expect(page).to have_content 'Rating:'
          expect(page).to have_link '+', href: %r{/answers/\d+\/vote_up}
          expect(page).to have_link '-', href: %r{/answers/\d+\/vote_down}
          expect(page).to have_link 'cancel', href: %r{/answers/\d+\/cancel_vote}
        end

        fill_in 'Your answer', with: 'some answer two'
        click_on 'Create'
      end

      Capybara.using_session('user') do
        expect(page).to have_link 'Best', href: %r{/answers/\d+\/set_best}
      end
    end
  end
end
