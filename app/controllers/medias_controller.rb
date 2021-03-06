class MediasController < ApplicationController
  include MediasHelper
  THUMB_WIDTH = 1300
  def index
    if !File.exist?(media_cache_path)
      FileUtils.mkdir_p(media_cache_path)
    end
    medias = Rails.cache.fetch('medias-controller-index', expires_in: 60.seconds) do
      Dir[media_path.join('*').to_s].sort_by{ |f| File.mtime(f) }.reverse.map do |path|
        handle_name = "handle_#{File.extname(path)[1..-1].downcase}".to_sym
        if methods.include? handle_name
          handle = method handle_name
          handle.call path
        else
          logger.warn "#{handle_name} not found."
        end
      end
    end
    render json: medias
  end

  def image
    render text: download_image(params[:uri], "#{Digest::SHA256.hexdigest(params[:uri])}.jpg")
  end

  def text
    render text: receive_text(params[:text])
  end

  protected

  def handle_txt(path)
    {
      type: 'text',
      text: File.read(path)
    }
  end

  def handle_jpg(path)
    name = File.basename path
    cache_path = media_cache_path.join(name).to_s
    if !File.exist?(cache_path)
      image = MiniMagick::Image.open(path)
      # width = image.width
      # while width > THUMB_WIDTH
      #   width /= 1.4
      # end
      image.resize("1000>x#{THUMB_WIDTH}>")
      image.write(cache_path)
    end
    meta = MiniMagick::Image.open(cache_path)
    {
      type: 'image',
      src: media_cache_uri(name),
      width: meta.width,
      height: meta.height,
      aspectRatio: (1.0 * meta.width / meta.height).round(2),
      lightboxImage: {
        src: media_uri(name),
      }
    }
  end
end
