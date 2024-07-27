require 'rails_helper'

RSpec.describe Relationship, type: :model do
  describe 'フォロー・フォロワーが作れるか' do
    it 'フォロー・フォロワーが作れる' do
      relationship = build(:relationship)
      relationship.valid?
      expect(relationship).to be_valid
    end
  end
end
