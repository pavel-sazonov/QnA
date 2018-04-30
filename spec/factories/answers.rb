FactoryBot.define do
  factory :answer do
    body "Answer"
    question nil
  end

  factory :invalid_answer, class: 'Answer' do
    body nil
  end
end
