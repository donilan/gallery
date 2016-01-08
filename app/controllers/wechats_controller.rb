class WechatsController < ApplicationController
  protect_from_forgery except: :create
  wechat_responder
  alias :index :create
  on :text do |request, content|
    request.reply.text "echo: #{content}"
  end
  on :image do |request|
    Rails.logger.info request.inspect
    request.reply.image(request[:MediaId])
  end
end
