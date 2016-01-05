class ImagesController < ApplicationController
  CACHE_PATH = Rails.public_path.join('cache', 'images')
  IMAGE_PATH = Rails.public_path.join('images')
  THUMB_WIDTH = 400
  def index
    if !File.exist?(CACHE_PATH)
      FileUtils.mkdir_p(CACHE_PATH)
    end
    images = Dir[IMAGE_PATH.join('*').to_s].map do |path|
      name = File.basename path
      cache_path = CACHE_PATH.join(name).to_s
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
        src: URI.join(request.original_url, '/cache/images/', name).to_s,
        width: meta.width,
        height: meta.height,
        aspectRatio: (1.0 * meta.width / meta.height).round(2),
        lightboxImage: {
          src: URI.join(request.original_url, '/images/', name).to_s,
        }
      }
    end
    render json: images
  end
end
