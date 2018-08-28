require_relative '../acceptance_helper'

feature 'Delete subscription', %q{
  As a subscribed user
  I can unsubscribe on the question
  On the question page
} do

  given(:user) { create(:user) }
  given(:another_user) { create(:user) }
  given(:question) { create(:question) }
  given!(:subscription) { create(:subscription, user: user, question: question) }

  scenario 'Subscribed user' do
    sign_in(user)
    visit question_path(question)
    expect(page).to_not have_link 'subscribe', href: "/questions/#{question.id}/subscriptions"
    click_on 'unsubscribe'

    expect(current_path).to eq question_path(question)
    expect(page).to_not have_link 'unsubscribe', href: "/subscriptions/#{subscription.id}"
    expect(page).to have_link 'subscribe', href: "/questions/#{question.id}/subscriptions"
  end

  scenario 'Non-subscribed user' do
    sign_in(another_user)
    visit question_path(question)

    expect(page).to_not have_link 'unsubscribe', href: "/subscriptions/#{subscription.id}"
    expect(page).to have_link 'subscribe', href: "/questions/#{question.id}/subscriptions"
  end

  scenario 'Guest' do
    visit question_path(question)
    expect(page).to_not have_link 'subscribe'
    expect(page).to_not have_link 'unsubscribe'
  end
end
