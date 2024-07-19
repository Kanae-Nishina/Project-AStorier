module FactoryBotHelpers
  def self.dummy_image(image_name, extention = 'webp')
    image = Base64.strict_encode64(File.read("spec/fixtures/images/#{image_name}"))
    decode_image = Base64.decode64(image)
    minimagick = MiniMagick::Image.read(decode_image)
    minimagick.format extention
    minimagick.to_blob
  end
end
