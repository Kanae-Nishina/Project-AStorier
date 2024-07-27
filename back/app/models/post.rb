# == Schema Information
#
# Table name: posts
#
#  title         :string           not null
#  caption       :string
#  publish_state :integer
#  published_at  :datetime
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  postable_type :string           not null
#  postable_id   :bigint           not null
#  uuid          :uuid             not null, primary key
#  user_uuid     :uuid             not null
#
class Post < ApplicationRecord
  self.primary_key = :uuid

  belongs_to :user, foreign_key: :user_uuid, primary_key: :uuid
  belongs_to :postable, polymorphic: true
  accepts_nested_attributes_for :postable

  has_many :post_tags, foreign_key: :post_uuid, dependent: :destroy
  has_many :tags, through: :post_tags, source: :tag
  has_many :post_synalios, foreign_key: :post_uuid, dependent: :destroy
  has_many :synalios, through: :post_synalios, source: :synalio
  has_many :favorites, foreign_key: :post_uuid, dependent: :destroy
  has_many :bookmarks, foreign_key: :post_uuid, dependent: :destroy
  has_many :post_game_systems, foreign_key: :post_uuid, dependent: :destroy
  has_many :post_comments, foreign_key: :post_uuid, dependent: :destroy
  has_many :comments, through: :post_comments

  validates :postable_type, presence: true
  validates :title, presence: true, length: { maximum: 20 }
  validates :caption, length: { maximum: 10_000 }
  enum publish_state: { draft: 0, all_publish: 1, only_url: 2, only_follower: 3, private_publish:4 }

  scope :search_by_title, ->(post_title) { where("title LIKE ?", "%#{post_title}%") }
  scope :search_by_tags, -> (tag_list) {
    tag_list.map {|tag| joins(:tags).where("tags.name LIKE ?", "%#{tag}%") }.reduce(:or)
  }
  scope :search_by_synalio, ->(synalio_name) { joins(:synalios).where("synalios.name LIKE ?", "%#{synalio_name}%") }
  scope :search_by_user, ->(user_name) { joins(:user).where("users.name LIKE ?", "%#{user_name}%") }
  scope :only_publish, -> { where(publish_state: 'all_publish') }
  scope :publish_at_desc, -> { order(published_at: :desc) }

  scope :useful_joins, -> { joins(:user, :tags, :synalios) }

  # uuidの短縮
  def short_uuid
    # base64で短縮
    # - を削除したあと16進数に変換、パディングの=を削除
    Base64.urlsafe_encode64([uuid.delete('-')].pack("H*")).tr('=', '')
  end

  # 短縮uuidから検索
  def self.find_by_short_uuid(short_uuid)
    # base64でデコード
    # uuidは「8-4-4-4-12」の形式（例：550e8400-e29b-41d4-a716-446655440000）
    # なので16進数から変換して-を挿入
    decode_uuid = Base64.urlsafe_decode64(short_uuid).unpack1("H*").insert(8, '-').insert(13, '-').insert(18, '-').insert(23, '-')
    find_by(uuid: decode_uuid)
  end

  # ゲームシステムでの検索
  def self.search_by_game_system(game_system_name)
    game_system = GameSystem.find_by(name: game_system_name)
    return none unless game_system

    joins(:post_game_systems).where(post_game_systems: { game_system_id: game_system.id })
  end

  # 公開可能か
  def publishable?(current_user=nil)
    case publish_state
    when 'draft'
      current_user == self.user
    when 'all_publish'
      true
    when 'only_url'
      true
    when 'only_follower'
      self.user.followers.include?(current_user)
    else
      current_user == self.user
    end
  end

  # タグの作成
  def create_tags(new_tags)
    return if new_tags.blank? || new_tags.all?(&:blank?)
    new_tags.each do |tag|
      next if tag.blank?
      new_tag = Tag.find_or_create_by(name: tag)
      post_tags.create(tag_id: new_tag.id)
    end
  end

  # タグの更新
  def update_tags(new_tags)
    # 登録しているタグを一旦全部消す
    post_tags.destroy_all

    # 再登録
    create_tags(new_tags)
  end

  # タグの取得
  def get_tags
    post_tags.map { |pt| Tag.find(pt.tag_id) }
  end

  # シナリオの作成
  def create_synalios(new_synalios)
    return if new_synalios.blank? || new_synalios.all?(&:blank?)
    new_synalios.each do |synalio|
      synalio_record = Synalio.find_or_create_by(name: synalio)
      post_synalios.create(synalio_id: synalio_record.id)
    end
  end

  # シナリオの更新
  def update_synalios(new_synalios)
    post_synalios.destroy_all
    create_synalios(new_synalios)
  end

  # シナリオの取得
  def get_synalios
    post_synalios.map { |ps| Synalio.find(ps.synalio_id) }
  end

  # システムの作成
  def create_game_systems(new_game_systems)
    return if new_game_systems.blank? || new_game_systems.all?(&:blank?)
    new_game_systems.each do |game_system|
      system = GameSystem.find_by(name: game_system)
      if system.present?
        post_game_systems.create(game_system_id: system.id)
      end
    end
  end

  # システムの更新
  def update_game_systems(new_game_systems)
    post_game_systems.destroy_all
    create_game_systems(new_game_systems)
  end

  # システムの取得
  def get_game_systems
    post_game_systems.map { |pgs| GameSystem.find(pgs.game_system_id)}
  end

  def initialize_postable(type)
    case type
    when 'Illust'
      Illust
    end
  end

  def get_postable
    postable.class.name
  end

  # 投稿タイプがイラストか
  def illust?
    postable.is_a?(Illust)
  end

  # 投稿のメインコンテンツの更新可能か
  def main_content_updatable?
    if illust?
      # イラストは未公開時のみ変更可能
      # 公開日時がなければ未公開なので更新可能
      published_at.nil?
    else
      # イラスト以外は更新可能
      true
    end
  end

  # 初公開なら公開日を設定
  def set_published_at(publish_state=nil)
    if publish_state != 'draft' && self.published_at.nil?
      self.published_at = Time.now
    end
  end

  # 未検索時用のカスタムjson
  def as_custom_index_json(content)
    {
      uuid: short_uuid,
      title: title,
      data: [content],
      user: {
        uuid: user.short_uuid,
        name: user.name,
        avatar: user.profile&.avatar&.url,
      }
    }
  end

  # 表示用のカスタムjson
  def as_custom_show_json(content)
    {
      uuid: short_uuid,
      title: title,
      caption: caption,
      synalio: get_synalios.map(&:name).first,
      game_systems: get_game_systems.map(&:name).first,
      tags: get_tags.map(&:name),
      data: content,
      user: {
        uuid: user.short_uuid,
        name: user.name,
        profile: user.profile&.text,
        avatar: user.profile&.avatar&.url,
        links: Link.get_links(user.uuid),
      },
      published_at: published_at&.strftime('%Y/%m/%d %H:%M:%S'),
    }
  end

  # 編集用のカスタムjson
  def as_custom_edit_json(content)
    {
      uuid: short_uuid,
      title: title,
      caption: caption,
      synalio: get_synalios.map(&:name).first,
      game_systems: get_game_systems.map(&:name).first,
      publish_state: publish_state,
      type: get_postable,
      tags: get_tags.map(&:name),
      data: content
    }
  end
end
