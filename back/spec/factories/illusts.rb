FactoryBot.define do
  factory :illust do
    trait(:with_image_one) do
      after(:create) do |illust|
        illust.illust_attachments << create(:illust_attachment)
      end
    end

    MAX_IMAGES_COUNT = 12
    trait(:with_images_twelve) do |illust|
      after(:create) do |illust|
        MAX_IMAGES_COUNT.times do
          illust.illust_attachments << create(:illust_attachment)
        end
      end
    end
  end
end
