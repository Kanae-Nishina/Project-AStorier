FactoryBot.define do
  factory :link do
    association :user

    trait :with_twitter do
      link_kind { :twitter }
      content { ENV['TWITTER_URL'] }
    end

    trait :with_pixiv do
      link_kind { :pixiv }
      content { ENV['PIXIV_URL'] }
    end

    trait :with_fusetter do
      link_kind { :fusetter }
      content { ENV['FUSETTER_URL'] }
    end

    trait :with_privatter do
      link_kind { :privatter }
      content { ENV['PRIVATTER_URL'] }
    end

    trait :with_other do
      link_kind { :other }
      content { ENV['OTHER_URL'] }
    end
  end
end
