module MediasHelper
  def media_path
    Rails.public_path.join('medias')
  end
  def media_cache_path
    Rails.public_path.join('cache', 'medias')
  end
  def media_cache_uri(name)
    URI.join(request.original_url, '/cache/medias/', name).to_s
  end
  def media_uri(name)
    URI.join(request.original_url, '/images/', name).to_s
  end

  def download_image(uri)
    logger.info("User uploading photo #{request[:PicUrl]}")
    dest_file_name = "#{request[:MediaId]}.jpg"
    dest = media_path.join(dest_file_name).to_s
    if File.exist? dest
      logger.info("Photo already exists.")
      Settings.image_already_exists
    else
      image = MiniMagick::Image::read(open(uri, 'rb'))
      image.write(dest)
      logger.info("Photo was saved already.")
      Settings.thanks_for_share
    end
  end

  def store_text(content)
    dest_file_name = "#{Digest::SHA256.hexdigest(content)}.txt"
    dest = media_path.join(dest_file_name).to_s
    File.write(dest, content)
  end
end
