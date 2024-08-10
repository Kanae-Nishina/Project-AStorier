require 'rails_helper'

RSpec.describe Post, type: :model do
  describe '投稿タイプ' do
    context '投稿タイプがない場合' do
      it '空値は保存できないこと' do
        post = build(:post)
        post.valid?
        expect(post.errors.full_messages).to include("Postable 投稿タイプを設定してください")
      end
    end

    context '投稿タイプがある場合' do
      it 'イラストの場合、保存できること' do
        post = build(:post, :with_illust)
        post.valid?
        expect(post).to be_valid
      end
    end

    context '投稿タイプがイラストの場合' do
      it 'イラストとして初期化できること' do
        post = build(:post)
        postable_type = Post.initialize_postable('Illust')
        post.postable = postable_type.new
        expect(post.postable.class.name).to eq 'Illust'
      end
    end
  end

  describe 'タイトル' do
    context 'タイトルがない場合' do
      it '空値は保存できないこと' do
        post = build(:post, :with_illust ,title: nil)
        post.valid?
        expect(post.errors.full_messages).to include("Title タイトルを入力してください")
      end
    end

    context 'タイトルがある場合' do
      it 'タイトルが20文字以内の場合、保存できること' do
        post = build(:post, :with_illust, title: 'a'*20)
        post.valid?
        expect(post).to be_valid
      end

      it 'タイトルが21文字以上の場合、保存できないこと' do
        post = build(:post, :with_illust, title: 'a'*21)
        post.valid?
        expect(post.errors.full_messages).to include("Title タイトルは20文字以内で入力してください")
      end

      it 'タイトルが重複していても保存できること' do
        post1 = create(:post, :with_illust)
        post2 = build(:post, :with_illust, title: post1.title)
        post2.valid?
        expect(post2).to be_valid
      end
    end
  end

  describe 'キャプション' do
    context 'キャプションがない場合' do
      it '空値は保存できること' do
        post = build(:post, :with_illust, caption: nil)
        post.valid?
        expect(post).to be_valid
      end
    end

    context 'キャプションがある場合' do
      it 'キャプションが10000文字以内の場合、保存できること' do
        post = build(:post, :with_illust, caption: 'a'*10000)
        post.valid?
        expect(post).to be_valid
      end

      it 'キャプションが10001文字以上の場合、保存できないこと' do
        post = build(:post, :with_illust, caption: 'a'*10001)
        post.valid?
        expect(post.errors.full_messages).to include("Caption キャプションは10000文字以内で入力してください")
      end

      it 'キャプションが重複していても保存できること' do
        post1 = create(:post, :with_illust)
        post2 = build(:post, :with_illust, caption: post1.caption)
        expect(post2).to be_valid
      end
    end
  end

  describe '投稿状態' do
    context '投稿状態がない場合' do
      it '空値は保存できないこと' do
        post = build(:post, :with_illust, publish_state: nil)
        post.valid?
        expect(post.errors.full_messages).to include("Publish state 公開状態を設定してください")
      end
    end

    context '投稿状態がある場合' do
      it '下書き保存できること' do
        post = build(:post, :with_illust, :draft, published_at: nil)
        post.valid?
        expect(post).to be_valid
      end

      it '全体公開で保存できること' do
        post = build(:post, :with_illust, :all_publish)
        post.valid?
        expect(post).to be_valid
      end

      it 'URLのみ公開で保存できること' do
        post = build(:post, :with_illust, :only_url)
        post.valid?
        expect(post).to be_valid
      end

      it 'フォロワーのみ公開で保存できること' do
        post = build(:post, :with_illust, :only_follower)
        post.valid?
        expect(post).to be_valid
      end

      it '非公開で保存できること' do
        post = build(:post, :with_illust, :private_publish)
        post.valid?
        expect(post).to be_valid
      end
    end

    context '投稿データの更新' do
      it '公開を一度もしていなければイラストそのものの更新ができる' do
        post = create(:post, :with_illust, :draft, published_at: nil)
        expect(post.main_content_updatable?).to be_truthy
      end

      it '公開を一度でもしていればイラストそのものの更新ができない' do
        post = create(:post, :with_illust, :all_publish)
        expect(post.main_content_updatable?).to be_falsey
      end

      it '初公開なら公開日時を設定' do
        post = create(:post, :with_illust, :draft, published_at: nil)
        post.set_published_at('all_publish')
        expect(post.published_at).not_to be_nil
      end
    end
  end

  describe '公開日時' do
    context '公開日時がない場合' do
      it '下書き保存時は空値を保存できること' do
        post = build(:post, :with_illust, :draft , published_at: nil)
        post.valid?
        expect(post).to be_valid
      end

      it '全体公開時は空値を保存できないこと' do
        post = build(:post, :with_illust, :all_publish, published_at: nil)
        post.valid?
        expect(post.errors.full_messages).to include("Published at 公開の場合は公開日時を設定してください")
      end

      it 'URLのみ公開時は空値を保存できないこと' do
        post = build(:post, :with_illust, :only_url, published_at: nil)
        post.valid?
        expect(post.errors.full_messages).to include("Published at 公開の場合は公開日時を設定してください")
      end

      it 'フォロワーのみ公開時は空値を保存できないこと' do
        post = build(:post, :with_illust, :only_follower, published_at: nil)
        post.valid?
        expect(post.errors.full_messages).to include("Published at 公開の場合は公開日時を設定してください")
      end

      it '非公開時は空値を保存できないこと' do
        post = build(:post, :with_illust, :private_publish, published_at: nil)
        post.valid?
        expect(post.errors.full_messages).to include("Published at 公開の場合は公開日時を設定してください")
      end
    end

    context '公開日時がある場合' do
      it '下書き保存時は保存できないこと' do
        post = build(:post, :with_illust, :draft, published_at: DateTime.now)
        post.valid?
        expect(post.errors.full_messages).to include("Published at 非公開時は公開日時を設定できません")
      end

      it '全体公開時は保存できること' do
        post = build(:post, :with_illust, :all_publish, published_at: Time.now)
        post.valid?
        expect(post).to be_valid
      end

      it 'URLのみ公開時は保存できること' do
        post = build(:post, :with_illust, :only_url, published_at: Time.now)
        post.valid?
        expect(post).to be_valid
      end

      it 'フォロワーのみ公開時は保存できること' do
        post = build(:post, :with_illust, :only_follower, published_at: Time.now)
        post.valid?
        expect(post).to be_valid
      end

      it '非公開時は保存できること' do
        post = build(:post, :with_illust, :private_publish, published_at: Time.now)
        post.valid?
        expect(post).to be_valid
      end

      it '公開日時が保存済みの場合、更新できないこと' do
        post = create(:post, :with_illust, :all_publish)
        post.published_at = Time.now
        post.valid?
        expect(post.errors.full_messages).to include("Published at 公開日時は変更できません")
      end

      it '公開日時が現在から1分以内の場合、保存できること' do
        post = build(:post, :with_illust, :all_publish, published_at: Time.now + 1.minute)
        post.valid?
        expect(post).to be_valid
      end

      it '公開日時が現在から1分より未来の場合、保存できないこと' do
        post = build(:post, :with_illust, :all_publish, published_at: Time.now + 2.minute)
        post.valid?
        expect(post.errors.full_messages).to include("Published at は現在時刻から1分を超えるのものは設定できません")

      end

      it '公開日時が現在から1分より過去の場合、保存できないこと' do
        post = build(:post, :with_illust, :all_publish, published_at: Time.now - 2.minute)
        post.valid?
        expect(post.errors.full_messages).to include("Published at は現在時刻から1分を超えるのものは設定できません")
      end
    end
  end

  describe 'データ取得' do
    context 'uuid' do
      it '短縮uuidが取得できること' do
        post = create(:post, :with_illust)
        expect(post.short_uuid.length).to eq 22
      end

      it '短縮uuidから投稿を取得できること' do
        post1 = create(:post, :with_illust)
        post2 = Post.find_by_short_uuid(post1.short_uuid)
        expect(post1).to eq post2
      end
    end

    context 'イラスト投稿' do
      it 'イラストかどうか判別できること' do
        post = create(:post, :with_illust)
        expect(post.illust?).to be_truthy
      end

      it '投稿タイプがイラストとして取得できること' do
        post = create(:post, :with_illust)
        expect(post.get_postable).to eq 'Illust'
      end
    end

    context '公開可能か' do
      it '下書きの場合、投稿ユーザーのみ閲覧可能であること' do
        post = create(:post, :with_illust, :draft , published_at: nil)
        user = post.user
        expect(post.publishable?(user)).to be_truthy
      end

      it '下書きの場合、投稿ユーザー以外は閲覧できないこと' do
        post = create(:post, :with_illust, :draft , published_at: nil)
        user = create(:user)
        expect(post.publishable?(user)).to be_falsey
      end

      it '全体公開の場合、全ユーザーが閲覧可能であること' do
        post = create(:post, :with_illust, :all_publish)
        user = create(:user)
        expect(post.publishable?(user)).to be_truthy
      end

      it 'URLのみ公開の場合、URLを知っている全ユーザーが閲覧可能であること' do
        post = create(:post, :with_illust, :only_url)
        user = create(:user)
        expect(post.publishable?(user)).to be_truthy
      end

      it 'フォロワーのみ公開の場合、フォロワーのみが閲覧可能であること' do
        post = create(:post, :with_illust, :only_follower)
        user = create(:user)
        post.user.followers << user
        post.save
        expect(post.publishable?(user)).to be_truthy
      end

      it 'フォロワーのみ公開の場合、フォロワー外のユーザーは閲覧できないこと' do
        post = create(:post, :with_illust, :only_follower)
        user = create(:user)
        expect(post.publishable?(user)).to be_falsey
      end

      it '非公開の場合、投稿ユーザーのみ閲覧可能であること' do
        post = create(:post, :with_illust, :private_publish)
        user = post.user
        expect(post.publishable?(user)).to be_truthy
      end

      it '非公開の場合、投稿ユーザー以外は閲覧できないこと' do
        post = create(:post, :with_illust, :private_publish)
        user = create(:user)
        expect(post.publishable?(user)).to be_falsey
      end
    end
  end
end
