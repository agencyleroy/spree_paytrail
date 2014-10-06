Spree::Core::Engine.add_routes do
  # Add your extension routes here
  resources :orders do
    resource :checkout, :controller => 'checkout' do
      member do
        get :paytrail_cancel
        get :paytrail_return
        get :skrill_cancel
        get :skrill_return
      end
    end
  end

  post '/paytrail' => 'paytrail_status#update'
  post '/skrill' => 'skrill_status#update'
end


  