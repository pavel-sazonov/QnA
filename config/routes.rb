Rails.application.routes.draw do
  devise_for :users
  root to: 'questions#index'

  resources :questions do
    post 'vote_up', on: :member
    post 'vote_down', on: :member
    delete 'cancel_vote', on: :member

    resources :answers, shallow: true do
      patch 'set_best', on: :member
    end
  end

  resources :attachments, only: :destroy
end
