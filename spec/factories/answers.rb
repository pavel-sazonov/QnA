FactoryBot.define do
  factory :answer do
    body "TestAnswerBody"
    question nil
  end

  factory :invalid_answer, class: 'Answer' do
    body nil
  end
end
