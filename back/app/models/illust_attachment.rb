# == Schema Information
#
# Table name: illust_attachments
#
#  id         :bigint           not null, primary key
#  illust_id  :bigint           not null
#  position   :integer          default(0), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class IllustAttachment < ApplicationRecord
  include AttachmentValidations
  belongs_to :illust
  has_validated_attachment :image
  validates :image, presence: true
  validates :position, presence: true
end
