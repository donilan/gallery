require 'digest'
require 'open-uri'

class WechatsController < ApplicationController
  include MediasHelper
  protect_from_forgery except: :create
  wechat_responder
  alias :index :create

  on :text do |request, content|
    # user = wechat.user(request[:FromUserName])
    # user['nickname']
    store_text("#{request[:FromUserName]}: #{content}")
  end

  on :image do |request|
    uri = URI(request[:PicUrl])
    request.reply.text download_image(uri)
  end

  on :event, with: 'subscribe' do |request|
    request.reply.text Settings.welcome_message
  end
end
