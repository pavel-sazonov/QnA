require 'rails_helper'

feature 'User sign out', %q{
  As an user
  I want to be able to sign out
  } do
    given(:user) { create(:user) }

    scenario 'Authenticated user tries to sign out' do
      sign_in(user)
      click_on 'Logout'

      expect(page).to have_content 'Signed out successfully.'
      expect(current_path).to eq root_path
    end
  end
