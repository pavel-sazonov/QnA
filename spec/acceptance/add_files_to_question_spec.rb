require_relative 'acceptance_helper'

feature 'Add files to question', %q{
  In order to illustrate my question
  As an question's author
  I want to be able to attach files
} do
  given(:user) { create(:user) }

  background do
    sign_in(user)
    visit new_question_path
    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'text text'
    attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"
  end

  scenario 'User adds file when asks question', js: true do
    click_on 'Create'

    expect(page).to have_link 'spec_helper.rb'#, href: "/uploads/test/attachment/file/53/spec_helper.rb"
  end

  scenario 'User adds two files when asks question', js: true do
    click_on 'add attachment'

    within '.nested-fields:nth-child(2)' do
      attach_file 'File', "#{Rails.root}/spec/rails_helper.rb"
    end

    click_on 'Create'

    expect(page).to have_link 'spec_helper.rb'#, href: "/uploads/test/attachment/file/54/spec_helper.rb"
    expect(page).to have_link 'rails_helper.rb'#, href: "/uploads/test/attachment/file/55/rails_helper.rb"
  end
end
