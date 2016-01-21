require 'digest'
require 'open-uri'

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
    URI.join(request.original_url, '/medias/', name).to_s
  end

  def download_image(uri, dest_file_name)
    logger.info("User uploading photo #{uri}")
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

  def names_path
    path = Rails.root.join('db', 'names')
    FileUtils.mkdir_p path unless File.exist? path
    path
  end

  def receive_text(text, who='test')
    text = text.nil? ? '' : text.strip
    return if text.blank?
    if /^#{Settings.i_am}/i =~ text
      name = text.sub(/^#{Settings.i_am}\s*/i, '')
      File.write names_path.join(who), name
      Settings.got_your_name
    else
      name = if File.exist? names_path.join(who)
               File.read names_path.join(who)
             else
               Settings.anonymous
             end
      store_text "#{name}: #{text}"
      return
    end
  end

  def store_text(content)
    dest_file_name = "#{Digest::SHA256.hexdigest(content)}.txt"
    dest = media_path.join(dest_file_name).to_s
    File.write(dest, content)
  end
end
