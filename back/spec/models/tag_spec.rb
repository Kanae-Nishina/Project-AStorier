require 'rails_helper'

RSpec.describe Tag, type: :model do
  describe 'nameのバリデーション' do
    it 'nameが登録できるか' do
      tag = build(:tag, name: 'test')
      tag.valid?
      expect(tag.errors.full_messages).to be_empty
    end

    it 'nameが空欄で登録できないか' do
      tag = build(:tag, name: '')
      tag.valid?
      expect(tag.errors.full_messages).to include('Name タグ名を入力してください')
    end

    it 'nameが重複して登録できないか' do
      create(:tag, name: 'test')
      tag = build(:tag, name: 'test')
      tag.valid?
      expect(tag.errors.full_messages).to include('Name タグ名が既に使用されています')
    end
  end
end
