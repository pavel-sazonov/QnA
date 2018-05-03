FactoryBot.define do
  factory :question do
    title "TestQuestionTitle"
    body "TestQuestionBody"
  end

  factory :invalid_question, class: 'Question' do
    title nil
    body nil
  end
end
