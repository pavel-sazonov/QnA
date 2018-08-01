require_relative "acceptance_helper"

feature "OmniAuth", %q(
  As an  user
  I want to be able to authorization with social networks
) do
  scenario "user can sign in with GitHub account" do
    visit "/users/sign_in"
    mock_auth_hash
    click_on "Sign in with GitHub"

    expect(page).to have_content "Successfully authenticated from github account."
    expect(page).to have_content "example@qna.com"
  end

  scenario "user can sign in with VK account" do
    visit "/users/sign_in"
    mock_auth_hash
    click_on "Sign in with Vkontakte"

    expect(page).to have_content "Successfully authenticated from vk account."
    expect(page).to have_content "example@qna.com"
  end

  scenario "can handle authentication error" do
    OmniAuth.config.mock_auth[:github] = :invalid_credentials
    visit "/users/sign_in"
    click_on "Sign in with GitHub"
    expect(page).to have_content "Could not authenticate you from GitHub because \"Invalid credentials\""
  end
end
