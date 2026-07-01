class User < ApplicationRecord
    has_many :messages, dependent: :destroy #Userはmessageを沢山もつ
end
