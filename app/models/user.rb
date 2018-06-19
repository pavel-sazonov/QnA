class User < ApplicationRecord
  has_many :questions
  has_many :answers
  has_many :votes
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  def author_of?(item)
    id == item.user_id
  end

  def vote(resource, value)
    if !author_of?(resource) && votes.empty?
      Vote.create(user: self, votable: resource, value: value)
    else
      false
    end
  end
end
