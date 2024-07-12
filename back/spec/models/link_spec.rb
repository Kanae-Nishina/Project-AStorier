require 'rails_helper'

RSpec.describe Link, type: :model do
  describe 'バリデーション' do
    it 'リンクの種類が空白なら無効な状態であること' do
      link = build(:link, link_kind: nil, content: ENV['TWITTER_URL'])
      link.valid?
      expect(link.errors[:link_kind]).to include('リンクタイプを選択してください')
    end
  end

  describe 'twitterの登録' do
    it 'twitterのリンクが登録できること' do
      link = build(:link, :with_twitter)
      link.valid?
      expect(link.errors.full_messages).to be_empty
    end

    it 'twitterのリンクが空欄なら登録できないこと' do
      link = build(:link, link_kind: :twitter, content: '')
      link.valid?
      expect(link.errors[:content]).to include('URLを入力してください')
    end
  end

  describe 'pixivの登録' do
    it 'pixivのリンクが登録できること' do
      link = build(:link, :with_pixiv)
      link.valid?
      expect(link.errors.full_messages).to be_empty
    end

    it 'pixivのリンクが空欄なら登録できないこと' do
      link = build(:link, link_kind: :pixiv, content: '')
      link.valid?
      expect(link.errors[:content]).to include('URLを入力してください')
    end
  end

  describe 'fusetterの登録' do
    it 'fusetterのリンクが登録できること' do
      link = build(:link, :with_fusetter)
      link.valid?
      expect(link.errors.full_messages).to be_empty
    end

    it 'fusetterのリンクが空欄なら登録できないこと' do
      link = build(:link, link_kind: :fusetter, content: '')
      link.valid?
      expect(link.errors[:content]).to include('URLを入力してください')
    end
  end

  describe 'privatterの登録' do
    it 'privatterのリンクが登録できること' do
      link = build(:link, :with_privatter)
      link.valid?
      expect(link.errors.full_messages).to be_empty
    end

    it 'privatterのリンクが空欄なら登録できないこと' do
      link = build(:link, link_kind: :privatter, content: '')
      link.valid?
      expect(link.errors[:content]).to include('URLを入力してください')
    end
  end

  describe 'otherの登録' do
    it 'otherのリンクが登録できること' do
      link = build(:link, :with_other)
      link.valid?
      expect(link.errors.full_messages).to be_empty
    end

    it 'otherのリンクが空欄なら登録できないこと' do
      link = build(:link, link_kind: :other, content: '')
      link.valid?
      expect(link.errors[:content]).to include('URLを入力してください')
    end
  end
end
