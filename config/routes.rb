# frozen_string_literal: true

Rails.application.routes.draw do
  root 'pages#home'
  get 'pages/home'

  resources :documents, only: %i[show index] do
    member do
      get 'preshow'
    end
  end

  post '/webhooks/stripe' => 'stripe_webhooks#handle_event'

  get 'purchased_documents', to: 'pages#purchased_documents', as: :purchased_documents
  post '/purchase_document/:document_id', to: 'documents#purchase_intent', as: :purchase_document
  get 'purchase_complete', to: 'purchase_complete#index'

  devise_for :users, controllers: { registrations: 'users/registrations' }
end
