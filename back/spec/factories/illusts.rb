FactoryBot.define do
  factory :illust do
    trait(:with_image_one) do
      after(:create) do |illust|
        illust_attachment =  build(:illust_attachment, :with_image, illust: illust)
        illust_attachment.save
      end
    end

    MAX_IMAGES_COUNT = 12
    trait(:with_images_twelve) do |illust|
      after(:create) do |illust|
        MAX_IMAGES_COUNT.times do
          illust_attachment =  build(:illust_attachment, :with_image, illust: illust)
          illust_attachment.save
        end
      end
    end
  end
end
