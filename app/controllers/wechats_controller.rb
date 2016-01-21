class WechatsController < ApplicationController
  include MediasHelper
  protect_from_forgery except: :create
  wechat_responder
  alias :index :create

  on :text do |request, content|
    # user = wechat.user(request[:FromUserName])
    # user['nickname']
    # store_text("#{request[:FromUserName]}: #{content}")
    reply = receive_text(content, request[:FromUserName])
    request.reply.text reply unless reply.nil?
  end

  on :image do |request|
    uri = URI(request[:PicUrl])
    dest_file_name = "#{Digest::SHA256.hexdigest(uri)}.jpg"
    request.reply.text download_image(uri, dest_file_name)
  end

  on :event, with: 'subscribe' do |request|
    request.reply.text Settings.welcome_message
  end
end
