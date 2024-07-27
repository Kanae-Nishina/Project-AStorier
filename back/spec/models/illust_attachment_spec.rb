require 'rails_helper'

RSpec.describe IllustAttachment, type: :model do
  let!(:post){ create(:illust) }

  describe 'イラストバリデーション' do
    it 'イラストが存在する場合、有効であること' do
      illust_attachment = build(:illust_attachment, illust: post)
      image_blob = FactoryBotHelpers.dummy_image('dummy.png')
      illust_attachment.image.attach(io: StringIO.new(image_blob),
                                      filename: SecureRandom.uuid,
                                      content_type: 'image/webp')
      illust_attachment.valid?
      expect(illust_attachment.errors[:image]).to be_empty
    end

    it 'イラストが存在しない場合、無効であること' do
      illust_attachment = build(:illust_attachment, illust: post)
      illust_attachment.valid?
      expect(illust_attachment.errors[:image]).to include('イラストを選択してください')
    end

    it 'イラストのサイズが10MB以下の場合、有効であること' do
      illust_attachment = build(:illust_attachment, illust: post)
      image_blob = FactoryBotHelpers.dummy_image('dummy.png')
      illust_attachment.image.attach(io: StringIO.new(image_blob),
                                      filename: SecureRandom.uuid,
                                      content_type: 'image/webp')
      illust_attachment.valid?
      expect(illust_attachment.errors[:image]).to be_empty
    end

    it 'イラストのサイズが10MBを超える場合、無効であること' do
      illust_attachment = build(:illust_attachment, illust: post)
      image_blob = FactoryBotHelpers.dummy_image('over_10_mb.jpg')
      illust_attachment.image.attach(io: StringIO.new(image_blob),
                                      filename: SecureRandom.uuid,
                                      content_type: 'image/webp')
      illust_attachment.valid?
      expect(illust_attachment.errors[:image]).to include('イラストは10MB以下のファイルを選択してください')
    end

    it 'イラストの拡張子がwebpで保存できること' do
      illust_attachment = build(:illust_attachment, illust: post)
      image_blob = FactoryBotHelpers.dummy_image('dummy.png', 'webp')
      illust_attachment.image.attach(io: StringIO.new(image_blob),
                                      filename: SecureRandom.uuid,
                                      content_type: 'image/webp')
      illust_attachment.valid?
      expect(illust_attachment.errors[:image]).to be_empty
    end

    it 'イラストの拡張子がwebp以外の場合、無効であること' do
      illust_attachment = build(:illust_attachment, illust: post)
      image_blob = FactoryBotHelpers.dummy_image('dummy.png', 'jpg')
      illust_attachment.image.attach(io: StringIO.new(image_blob),
                                      filename: SecureRandom.uuid,
                                      content_type: 'image/jpg')
      illust_attachment.valid?
      expect(illust_attachment.errors[:image]).to include('イラスト形式はwebpのみ対応しています')
    end

    it 'イラストの表示位置がある場合、保存できること' do
      illust_attachment = build(:illust_attachment, illust: post, position: 1)
      illust_attachment.valid?
      expect(illust_attachment.errors[:position]).to be_empty
    end

    it 'イラストの表示位置がない場合、無効であること' do
      illust_attachment = build(:illust_attachment, illust: post, position: nil)
      illust_attachment.valid?
      expect(illust_attachment.errors[:position]).to include('イラストの表示順を設定してください')
    end
  end
end
