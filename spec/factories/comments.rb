FactoryBot.define do
  factory :comment do
    body "MyText"
    commentable nil
  end

  factory :invalid_comment, class: 'Comment' do
    body nil
  end
end
