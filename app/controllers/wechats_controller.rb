require 'open-uri'

class WechatsController < ApplicationController
  protect_from_forgery except: :create
  wechat_responder
  alias :index :create

  # on :text do |request, content|
  #   request.reply.text "echo: #{content}"
  # end

  on :image do |request|
    uri = URI(request[:PicUrl])
    logger.info("User uploading photo #{request[:PicUrl]}")
    dest_file_name = "#{request[:PicUrl].gsub(/[\:\/]+/, '_')}.jpg"
    dest = Rails.public_path.join('images', dest_file_name).to_s
    if File.exist? dest
      logger.info("Photo already exists.")
      request.reply.text Settings.image_already_exists
    else
      image = MiniMagick::Image::read(open(uri, 'rb'))
      image.write(dest)
      logger.info("Photo was saved already.")
      request.reply.text Settings.thanks_for_share
    end
  end

  on :event, with: 'subscribe' do |request|
    request.reply.text Settings.welcome_message
  end
end
