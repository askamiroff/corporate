Rails.application.routes.draw do
  scope module: :web do
    concern :with_acts do |options|
      resources :acts, options
    end

    root to: 'welcome#index'
    resource :session
    resources :users do
      scope module: :users do
        resource :statistics
        resource :pm_bonus
      end
    end
    resources :projects do
      member do
        patch :status
      end
      scope module: :projects do
        resource :finish
      end
    end
    resources :tasks do
      member do
        patch :status
      end
      scope module: :tasks do
        resources :comments
      end
    end
    resources :counterparties do
      scope module: :counterparties do
        resources :officials
      end
    end
    namespace :account do
      resources :invites
    end
    resources :contracts do
      concerns :with_acts, document_type: 'Contract', document_id_key: :contract_id
      scope module: :contracts do
        resources :supplementary_agreements
        resources :appendixes
      end
    end
    resources :supplementary_agreements do
      concerns :with_acts, document_type: 'Contract::SupplementaryAgreement', document_id_key: :supplementary_agreement_id
    end
    resources :service_kinds
  end

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
