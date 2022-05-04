Rails.application.routes.draw do
	resources :attempt_answers


  get "/a/:quiz_id", to: "attempts#new", as: :attempt_to
  get "/a/:id/:auth_code", to: "attempts#edit", as: :attempt_with
  resources :attempts do
    collection do
      get :notice
      get :unavailable
    end
    resources :attempt_answers
  end

  resources :question_options

  resources :questions do
    member do 
      put :up
      put :down
    end
    resources :question_options
  end

  resources :quizzes do
    member do
      post :clone
      get :moniter
    end
    resources :questions
    resources :attempts
  end

  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  root "quizzes#index"

end
