FactoryBot.define do
  factory :question do
    title "MyString"
    body "Question"
  end

  factory :invalid_question, class: 'Question' do
    title nil
    body nil
  end
end
