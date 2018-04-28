require 'rails_helper'

feature 'User register', %q{
  As unregistered user
  I want to be able to register
} do

  given(:user) { create(:user) }

  scenario 'Unregistered user tries to register' do
    visit new_user_registration_path
    fill_in 'Email', with: 'test@test.com'
    fill_in 'Password', with: '123456'
    fill_in 'Password confirmation', with: '123456'
    click_on 'Sign up'

    expect(page).to have_content 'Welcome! You have signed up successfully.'
  end

  scenario 'Registered user tries to register' do
    visit new_user_registration_path
    fill_in 'Email', with: user.email
    fill_in 'Password', with: '123456'
    fill_in 'Password confirmation', with: '123456'
    click_on 'Sign up'

    expect(page).to have_content 'Email has already been taken'
  end
end
