# == Schema Information
#
# Table name: links
#
#  id         :bigint           not null, primary key
#  user_uuid  :uuid             not null
#  link_kind  :integer          not null
#  content    :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Link < ApplicationRecord
  belongs_to :user, primary_key: :uuid, foreign_key: :user_uuid
  enum link_kind: { twitter: 0, pixiv: 1, fusetter: 2, privatter: 3, other: 4}

  validates :link_kind, presence: true
  validates :content, presence: true

  def self.set_links(user_uuid, links)
    links.each do |link_kind, link_url|
      Rails.logger.info("link_kind: #{link_kind}, link_url: #{link_url}")
      if link_url.blank?
        Link.find_by(user_uuid: user_uuid, link_kind: link_kind)&.destroy
        next
      end
      link = Link.find_by(user_uuid: user_uuid, link_kind: link_kind)
      link_content = get_content_id(link_kind, link_url)
      if link
        link.update(content: link_content)
      else
        Link.create(user_uuid: user_uuid, link_kind: link_kind, content: link_content)
      end
    end
  end

  def self.get_links(user_uuid)
    links = Link.where(user_uuid: user_uuid)
    {
      twitter: links.find_by(link_kind: :twitter)&.content,
      pixiv: links.find_by(link_kind: :pixiv)&.content,
      fusetter: links.find_by(link_kind: :fusetter)&.content,
      privatter: links.find_by(link_kind: :privatter)&.content,
      other: links.find_by(link_kind: :other)&.content
    }
  end

  private

  def self.get_content_id(link_kind, link_url)
    if link_kind == Link.link_kinds[:other]
      link_url
    else
      link_url.split('/').last
    end
  end
end
