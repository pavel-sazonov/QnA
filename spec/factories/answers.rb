FactoryBot.define do
  factory :answer do
    sequence(:body) { |n| "TestAnswerBody-#{n}" }

    question { create :question }
    user { create :user }
  end

  factory :invalid_answer, class: 'Answer' do
    body nil
  end
end
