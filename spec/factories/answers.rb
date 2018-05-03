FactoryBot.define do
  sequence :body do |n|
    "TestAnswerBody-#{n}"
  end

  factory :answer do
    body
    question nil
  end

  factory :invalid_answer, class: 'Answer' do
    body nil
  end
end
