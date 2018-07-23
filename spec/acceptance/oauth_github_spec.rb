require_relative "acceptance_helper"

feature "GitHub authorization", %q(
  As an  user
  I want to be able to authorization with GitHub
) do
  scenario "user can sign in with GitHub account" do
    visit "/users/sign_in"
    mock_auth_hash
    click_on "Sign in with GitHub"

    expect(page).to have_content "Successfully authenticated from github account."
    expect(page).to have_content "example@qna.com"
  end
end
