FactoryBot.define do
  factory :post, class: 'Post' do
    association :user
    sequence(:title) { |n| "title#{n}" }
    caption { 'caption' }
    publish_state { Post.publish_states[:all_publish] }
    published_at { DateTime.now }

    Post.publish_states.each do |state|
      trait(state) do |state|
        publish_state { Post.publish_states[state] }
      end
    end

    trait :with_tags do
      after(:create) do |post|
        post.tags << create(:tag)
      end
    end

    trait :with_synalios do
      after(:create) do |post|
        post.synalios << create(:synalio)
      end
    end

    trait :with_illust do
      postable { create(:illust) }
      postable_type { 'Illust' }
    end

    trait :with_illust_one do
      postable { create(:illust, :with_image_one) }
      postable_type { 'Illust' }
    end

    trait :with_illust_twelve do
      postable { create(:illust, :with_images_twelve) }
      postable_type { 'Illust' }
    end
  end
end
