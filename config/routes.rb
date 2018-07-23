Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: 'omniauth_callbacks' }

  root to: 'questions#index'

  concern :votable do
    member do
      post 'vote_up'
      post 'vote_down'
      delete 'cancel_vote'
    end
  end

  concern :commentable do
    resources :comments, only: %i[create destroy]
  end

  resources :questions, concerns: %i[votable commentable], shallow: true do
    resources :answers, concerns: %i[votable commentable] do
      patch 'set_best', on: :member
    end
  end

  resources :attachments, only: :destroy

  mount ActionCable.server => '/cable'
end
