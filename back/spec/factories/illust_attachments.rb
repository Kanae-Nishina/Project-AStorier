FactoryBot.define do
  factory :illust_attachment do
    association :illust
    sequence(:position) { |n| n }
    after(:create) do |illust_attachment|
      image_blob = FactoryBotHelpers.dummy_image('dummy.png')
      illust_attachment.image.attach(io: StringIO.new(image_blob),
                                    filename: SecureRandom.uuid,
                                    content_type: 'image/webp')
    end
  end
end