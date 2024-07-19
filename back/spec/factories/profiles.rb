FactoryBot.define do
  factory :profile do
    association :user
    text { "profile text" }

    trait :with_avatar do
      after(:create) do |profile|
        image_blob = FactoryBotHelpers.dummy_image('dummy.png')
        profile.avatar.attach(io: StringIO.new(image_blob),
                              filename: SecureRandom.uuid,
                              content_type: 'image/webp')
      end
    end

    trait :with_header_image do
      after(:create) do |profile|
        image_blob = FactoryBotHelpers.dummy_image('dummy.png')
        profile.header_image.attach(io: StringIO.new(image_blob),
                                    filename: SecureRandom.uuid,
                                    content_type: 'image/webp')
      end
    end

    trait :with_avatar_and_header_image do
      after(:create) do |profile|
        image_blob = FactoryBotHelpers.dummy_image('dummy.png')
        profile.avatar.attach(io: StringIO.new(image_blob),
                              filename: SecureRandom.uuid,
                              content_type: 'image/webp')
        profile.header_image.attach(io: StringIO.new(image_blob),
                                    filename: SecureRandom.uuid,
                                    content_type: 'image/webp')
      end
    end
  end
end