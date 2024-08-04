# == Schema Information
#
# Table name: illusts
#
#  id         :bigint           not null, primary key
#  image      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Illust < ApplicationRecord
  has_one :post, as: :postable, foreign_key: :user_uuid, dependent: :destroy
  has_many :illust_attachments, -> {order(:position)}, dependent: :destroy

  validate :illust_attachments_count_within_limit

  def illust_images_update!(data_images)
    transaction do
      begin
        updated_image = []
        data_images.each_with_index do |data_image, index|
          if data_image[:body].start_with?('http')
            # 既存の画像を検索し、順番が変わっている場合は更新
            illust_attachment = illust_attachments.find_by(position: data_image[:position])
            if illust_attachment && illust_attachment.position != index + 1
              illust_attachment.update!(position: index + 1)
            end
            updated_image << illust_attachment
          else
            updated_image << illust_image_create!(data_image[:body], index)
          end
        end

        # 更新ファイルにないものを削除
        if updated_image.present?
          illust_attachments.where.not(id: updated_image.map(&:id)).destroy_all
        end

        true
      rescue => e
        Rails.logger.error("画像の保存に失敗しました: #{e.message}")
        false
      end
    end
  end

  def illust_images_create!(data_images)
    begin
      data_images.each_with_index do |data_image, index|
        unless illust_image_create!(data_image[:body], index)
          raise StandardError
          return false
        end
      end
      true
    rescue => e
      Rails.logger.error(e.message)
      Rails.logger.error(e.backtrace.join("\n"))
      false
    end
  end

  def get_first_image
    if illust_attachments.present?
      illust_attachments.first.image
    else
      raise StandardError, "画像がありません"
    end
  end

  private

  def illust_image_create!(data_image, index)
    # 送信されるデータは data: から始まるためエンコードデータのみ抽出
    base64_data = data_image
    if base64_data.start_with?('data:image')
      base64_data = data_image.split(",")[1]
    end
    decoded_image = Base64.decode64(base64_data)
    # MiniMagickでwebpに軽量化
    img = MiniMagick::Image.read(decoded_image)
    img.format 'webp'

    blob = ActiveStorage::Blob.create_and_upload!(
      io: StringIO.new(img.to_blob),
      filename: SecureRandom.uuid,
      content_type: 'image/webp'
      )
    illust_attachment = illust_attachments.create!(position: index + 1)
    illust_attachment.image.attach(blob)
    illust_attachment.save!
    illust_attachment
  end

  def illust_attachments_count_within_limit
    if illust_attachments.size > 12
      errors.add(:illust_attachments, "イラストは12枚まで選択できます")
    end
  end
end