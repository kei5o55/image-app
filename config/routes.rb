Rails.application.routes.draw do
 
  namespace :api do
    namespace :v1 do
      # 疎通確認用
      get 'health', to: 'health#index'
      # タグから画像を検索用
      get "image", to: "image#search"
      # 存在するtagを取得
      get "tags", to: "tags#index"
      # チャンネル一覧
      resources :channels, only: [:index, :create] do
        # チャンネルに紐づくメッセージ一覧 & 作成
        resources :messages, only: [:index, :create]
      end
    end
  end
end