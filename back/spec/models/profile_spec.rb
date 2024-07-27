require 'rails_helper'

RSpec.describe Profile, type: :model do
  describe 'textのバリデーション' do
    it 'textが空欄で登録できるか' do
      profile = build(:profile, text: '')
      profile.valid?
      expect(profile.errors.full_messages).to be_empty
    end

    it 'textが登録できるか' do
      profile = build(:profile, text: 'test')
      profile.valid?
      expect(profile.errors.full_messages).to be_empty
    end

    it 'textが1000文字で登録できるか' do
      profile = build(:profile, text: 'a' * 1000)
      profile.valid?
      expect(profile.errors.full_messages).to be_empty
    end

    it 'textが1001文字で登録できないか' do
      profile = build(:profile, text: 'a' * 1001)
      profile.valid?
      expect(profile.errors.full_messages).to include('Text プロフィールは1000文字以内で入力してください')
    end
  end

  describe 'avatarのバリデーション' do
    it 'avatarが登録できるか' do
      profile = create(:profile, :with_avatar)
      profile.valid?
      expect(profile.errors.full_messages).to be_empty
    end

    it 'avatarが空欄で登録できるか' do
      profile = create(:profile)
      profile.valid?
      expect(profile.errors.full_messages).to be_empty
    end

    it 'avatarの容量が10MB以下で登録できるか' do
      profile = create(:profile)
      image_blob = FactoryBotHelpers.dummy_image('dummy.png')
      profile.avatar.attach(io: StringIO.new(image_blob),
                            filename: SecureRandom.uuid,
                            content_type: 'image/webp')
      profile.valid?
      expect(profile.errors.full_messages).to be_empty
    end

    it 'avatarの容量が10MB以上で登録できないか' do
      profile = create(:profile)
      image_blob = FactoryBotHelpers.dummy_image('over_10_mb.jpg')
      profile.avatar.attach(io: StringIO.new(image_blob),
                            filename: SecureRandom.uuid,
                            content_type: 'image/webp')
      profile.valid?
      expect(profile.errors.full_messages).to include('Avatar 画像は10MB以下のファイルを選択してください')
    end

    it 'avatarの拡張子がwebpで登録できるか' do
      profile = create(:profile)
      image_blob = FactoryBotHelpers.dummy_image('dummy.png', 'webp')
      profile.avatar.attach(io: StringIO.new(image_blob),
                            filename: SecureRandom.uuid,
                            content_type: 'image/webp')
      profile.valid?
      expect(profile.errors.full_messages).to be_empty
    end

    it 'avatarの拡張子がwebp以外で登録できないか' do
      profile = create(:profile)
      image_blob = FactoryBotHelpers.dummy_image('dummy.png', 'jpg')
      profile.avatar.attach(io: StringIO.new(image_blob),
                            filename: SecureRandom.uuid,
                            content_type: 'image/jpg')
      profile.valid?
      expect(profile.errors.full_messages).to include('Avatar 画像形式はwebpのみ対応しています')
    end
  end

  describe 'header_imageのバリデーション' do
    it 'header_imageが登録できるか' do
      profile = create(:profile, :with_header_image)
      profile.valid?
      expect(profile.errors.full_messages).to be_empty
    end

    it 'header_imageが空欄で登録できるか' do
      profile = create(:profile)
      profile.valid?
      expect(profile.errors.full_messages).to be_empty
    end

    it 'header_imageの容量が10MB以下で登録できるか' do
      profile = create(:profile)
      image_blob = FactoryBotHelpers.dummy_image('dummy.png')
      profile.header_image.attach(io: StringIO.new(image_blob),
                                  filename: SecureRandom.uuid,
                                  content_type: 'image/webp')
      profile.valid?
      expect(profile.errors.full_messages).to be_empty
    end

    it 'header_imageの容量が10MB以上で登録できないか' do
      profile = create(:profile)
      image_blob = FactoryBotHelpers.dummy_image('over_10_mb.jpg')
      profile.header_image.attach(io: StringIO.new(image_blob),
                                  filename: SecureRandom.uuid,
                                  content_type: 'image/webp')
      profile.valid?
      expect(profile.errors.full_messages).to include('Header image 画像は10MB以下のファイルを選択してください')
    end

    it 'header_imageの拡張子がwebpで登録できるか' do
      profile = create(:profile)
      image_blob = FactoryBotHelpers.dummy_image('dummy.png', 'webp')
      profile.header_image.attach(io: StringIO.new(image_blob),
                                  filename: SecureRandom.uuid,
                                  content_type: 'image/webp')
      profile.valid?
      expect(profile.errors.full_messages).to be_empty
    end

    it 'header_imageの拡張子がwebp以外で登録できないか' do
      profile = create(:profile)
      image_blob = FactoryBotHelpers.dummy_image('dummy.png', 'jpg')
      profile.header_image.attach(io: StringIO.new(image_blob),
                                  filename: SecureRandom.uuid,
                                  content_type: 'image/jpg')
      profile.valid?
      expect(profile.errors.full_messages).to include('Header image 画像形式はwebpのみ対応しています')
    end
  end
end
