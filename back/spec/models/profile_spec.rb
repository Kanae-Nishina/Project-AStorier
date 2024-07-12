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
end
