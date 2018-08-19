FactoryBot.define do
  factory :vote do
    user { create :user }
    votable { create :question }
    value 1
  end
end
