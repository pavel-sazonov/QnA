require_relative '../acceptance_helper'

feature 'Create subscription', %q{
  As a user
  I can subscribe on the question
  On the question page
} do

  given(:user) { create(:user) }
  given(:question) { create(:question) }

  scenario 'Authenticated user' do
    sign_in(user)
    visit question_path(question)
    expect(page).to_not have_link 'unsubscribe'
    click_on 'subscribe'
    expect(current_path).to eq question_path(question)

    subscription = question.subscriptions.find_by(user: user)
    expect(page).to_not have_link 'subscribe', href: "/questions/#{question.id}/subscriptions"
    expect(page).to have_link 'unsubscribe', href: "/subscriptions/#{subscription.id}"
  end

  scenario 'Guest' do
    visit question_path(question)
    expect(page).to_not have_link 'subscribe'
  end
end
