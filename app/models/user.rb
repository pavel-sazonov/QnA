class User < ApplicationRecord
  has_many :questions
  has_many :answers
  has_many :votes
  has_many :comments
  has_many :authorizations

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable,
         :validatable, :omniauthable, omniauth_providers: %i[github vkontakte]

  def self.find_for_oauth(auth)
    authorization = Authorization.where(provider: auth.provider, uid: auth.uid.to_s).first
    return authorization.user if authorization

    email = auth.info[:email]
    user = User.where(email: email).first
    # if user
    #   user.create_authorization(auth)
    # else
    #   password = Devise.friendly_token[0, 20]
    #   user = User.create!(email: email, password: password, password_confirmation: password)
    #   user.create_authorization(auth)
    # end

    unless user
      password = Devise.friendly_token[0, 20]
      user = User.create!(email: email, password: password, password_confirmation: password)
    end

    user.create_authorization(auth)

    user
  end

  def create_authorization(auth)
    authorizations.create(provider: auth.provider, uid: auth.uid)
  end

  def author_of?(item)
    id == item.user_id
  end

  def vote(resource, value)
    if !author_of?(resource) && resource.voted_by(self).empty?
      votes.create(votable: resource, value: value)
    else
      false
    end
  end
end
