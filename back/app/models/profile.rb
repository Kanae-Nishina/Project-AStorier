# == Schema Information
#
# Table name: profiles
#
#  id           :bigint           not null, primary key
#  avatar       :string
#  header_image :string
#  text         :text
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  user_uuid    :uuid             not null
#
class Profile < ApplicationRecord
  belongs_to :user, foreign_key: :user_uuid, primary_key: :uuid
  validates :text, length: { maximum: 250 }

  has_one_attached :header_image
  has_one_attached :avatar

  # ヘッダー画像の保存
  def save_header_image(image)
    transaction do
      begin
        blob = get_blob(image)
        header_image.attach(blob)
        true
      rescue => e
        Rails.logger.error("ヘッダー画像の保存に失敗しました: #{e.message}")
        false
      end
    end
  end

  def save_avatar(image)
    transaction do
      begin
        blob = get_blob(image)
        avatar.attach(blob)
        true
      rescue => e
        Rails.logger.error("アバター画像の保存に失敗しました: #{e.message}")
        false
      end
    end
  end

  def get_blob(image)
    # URLの場合は保存しない
    return true if image.start_with?('http')

    base64_data = image
    if base64_data.start_with?('data:image')
      base64_data = image.split(",")[1]
    end

    decoded_image = Base64.decode64(base64_data)
    # MiniMagickでwebpに軽量化
    img = MiniMagick::Image.read(decoded_image)
    img.format 'webp'

    ActiveStorage::Blob.create_and_upload!(
      io: StringIO.new(img.to_blob),
      filename: SecureRandom.uuid,
      content_type: 'image/webp'
    )
  end
end
