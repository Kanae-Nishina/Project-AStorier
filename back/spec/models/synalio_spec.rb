require 'rails_helper'

RSpec.describe Synalio, type: :model do
  describe 'nameのバリデーション' do
    it 'nameが登録できるか' do
      synalio = build(:synalio, name: 'test')
      expect(synalio).to be_valid
      expect(synalio.errors.full_messages).to be_empty
    end

    it 'nameが空欄で登録できないか' do
      synalio = build(:synalio, name: '')
      synalio.valid?
      expect(synalio.errors.full_messages).to include('Name シナリオ名を入力してください')
    end

    it 'nameが重複して登録できないか' do
      create(:synalio, name: 'test')
      synalio2 = build(:synalio, name: 'test')
      synalio2.valid?
      expect(synalio2.errors.full_messages).to include('Name シナリオ名が既に使用されています')
    end
  end
end
