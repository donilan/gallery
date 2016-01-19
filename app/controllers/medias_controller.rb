class MediasController < ApplicationController
  include MediasHelper
  THUMB_WIDTH = 400
  def index
    if !File.exist?(media_cache_path)
      FileUtils.mkdir_p(media_cache_path)
    end
    images = Dir[media_path.join('*').to_s].sort_by{ |f| File.mtime(f) }.reverse.map do |path|
      name = File.basename path
      cache_path = media_cache_path.join(name).to_s
      if !File.exist?(cache_path)
        image = MiniMagick::Image.open(path)
        width = image.width
        while width > THUMB_WIDTH
          width /= 1.4
        end
        image.resize("1000>x#{width}>")
        image.write(cache_path)
      end
      meta = MiniMagick::Image.open(cache_path)
      {
        src: media_cache_uri(name),
        width: meta.width,
        height: meta.height,
        aspectRatio: (1.0 * meta.width / meta.height).round(2),
        lightboxImage: {
          src: media_uri(name),
        }
      }
    end
    render json: images
  end
end
