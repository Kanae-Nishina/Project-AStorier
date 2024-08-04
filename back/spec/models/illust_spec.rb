require 'rails_helper'

RSpec.describe Illust, type: :model do
  describe 'Illustを生成できるか' do
    it '1枚イラストを保存できる' do
      illust = create(:illust, :with_image_one)
      expect(illust).to be_valid
      expect(illust.illust_attachments.count).to eq(1)
    end

    it '12枚イラストを保存できる' do
      illust = create(:illust, :with_images_twelve)
      expect(illust).to be_valid
      expect(illust.illust_attachments.count).to eq(12)
    end

    it '13枚イラストを保存できない' do
      illust = create(:illust)
      13.times do
        illust_attachment = build(:illust_attachment, :with_image, illust: illust)
        illust_attachment.save
      end
      illust.valid?
      expect(illust.errors[:illust_attachments]).to include('イラストは12枚まで選択できます')
    end
  end
end
