require_relative 'acceptance_helper'

feature 'Add files to answer', %q{
  In order to illustrate my answer
  As an answer's author
  I want to be able to attach files
} do
  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }

  background do
    sign_in(user)
    visit question_path(question)
    fill_in 'Your answer', with: 'text text'
    attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"
  end

  scenario 'User adds file when answer the question', js: true do
    click_on 'Create'

    expect(page).to have_link 'spec_helper.rb',
                              href: %r{/uploads/test/attachment/file/\d+\/spec_helper.rb}
  end

  scenario 'User adds two files when answer the question', js: true do
    click_on 'add attachment'

    within '.nested-fields:nth-child(2)' do
      attach_file 'File', "#{Rails.root}/spec/rails_helper.rb"
    end

    click_on 'Create'

    within '.answers' do
      expect(page).to have_link 'spec_helper.rb',
                                href: %r{/uploads/test/attachment/file/\d+\/spec_helper.rb}
      expect(page).to have_link 'rails_helper.rb',
                                href: %r{/uploads/test/attachment/file/\d+\/rails_helper.rb}
    end
  end
end
