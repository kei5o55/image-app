class MessagesChannel < ApplicationCable::Channel
  # フロントから接続（subscribe）された時に呼ばれる
  def subscribed
    # チャンネルIDごとに部屋（ストリーム）を分ける
    channel = Channel.find(params[:channel_id])
    stream_for channel
  end

  def unsubscribed
    # 切断時の処理（必要に応じて）
  end
end