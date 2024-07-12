require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'バリデーションが機能しているか' do
    it '正常に登録できるか' do
      user = build(:user)
      user.valid?
      expect(user.errors.full_messages).to be_empty
    end

    it 'uidがないと登録できない' do
      user = build(:user, uid: nil)
      user.valid?
      expect(user.errors.full_messages).to include('Uid を入力してください')
    end

    it 'providerがないと登録できない' do
      user = build(:user, provider: nil)
      user.valid?
      expect(user.errors.full_messages).to include('Provider を入力してください')
    end

    it 'emailがないと登録できない' do
      user = build(:user, email: nil)
      user.valid?
      expect(user.errors.full_messages).to include('Eメール を入力してください')
    end

    it 'emailが重複していると登録できない' do
      create(:user, email: 'test@test.com')
      user = build(:user, email: 'test@test.com')
      user.valid?
      expect(user.errors.full_messages).to include('Eメール が既に使用されています')
    end

    it 'emailが形式に沿っていないと登録できない' do
      user = build(:user, email: 'test')
      user.valid?
      expect(user.errors.full_messages).to include('Eメール は有効ではありません')
    end

    it 'passwordがないと登録できない' do
      user = build(:user, password: nil)
      user.valid?
      expect(user.errors.full_messages).to include('パスワード を入力してください')
    end

    it 'passwordが6文字未満だと登録できない' do
      user = build(:user, password: 'test')
      user.valid?
      expect(user.errors.full_messages).to include('パスワード は6文字以上で入力してください')
    end

    it 'nameがないと登録できない' do
      user = build(:user, name: nil)
      user.valid?
      expect(user.errors.full_messages).to include('Name を入力してください')
    end
  end
end
