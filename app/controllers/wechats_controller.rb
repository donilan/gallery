require 'digest'
require 'open-uri'

class WechatsController < ApplicationController
  protect_from_forgery except: :create
  wechat_responder
  alias :index :create

  on :text do |request, content|
    dest_file_name = "#{Digest::SHA256.hexdigest(content)}.json"
    dest = public_image_folder(dest_file_name)
    # user = wechat.user(request[:FromUserName])
    # user['nickname']
    File.write(dest, "#{request[:FromUserName]}: #{content}")
  end

  on :image do |request|
    uri = URI(request[:PicUrl])
    logger.info("User uploading photo #{request[:PicUrl]}")
    dest_file_name = "#{request[:PicUrl].gsub(/[\:\/]+/, '_')}.jpg"
    dest = public_image_folder(dest_file_name)
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

  private
  def public_image_folder(dest_file_name)
    Rails.public_path.join('images', dest_file_name).to_s
  end
end
