FactoryBot.define do
  factory :question do
    sequence(:title) { |n| "TestQuestionTitle-#{n}" }
    sequence(:body) { |n| "TestQuestionBody-#{n}" }
    user { create :user }
  end

  factory :invalid_question, class: 'Question' do
    title nil
    body nil
  end
end
