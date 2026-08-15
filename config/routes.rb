Rails.application.routes.draw do
  get "image/index"
  namespace :api do
    namespace :v1 do
      # 疎通確認用
      get 'health', to: 'health#index'

      # チャンネル一覧
      resources :channels, only: [:index] do
        # チャンネルに紐づくメッセージ一覧 & 作成
        resources :messages, only: [:index, :create]
      end
    end
  end
end