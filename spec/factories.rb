FactoryGirl.define do
  factory :user do
    username 'derpmaster'
    email 'derp@derpmaster.com'
    password 'test1234'
    password_confirmation { 'test1234' }
  end

  factory :category do
    sequence(:name) { |n| "category-#{n}" }
    association :battle_configuration
  end

  factory :bot do
    user
    jar_file_file_name { 'derp_bot_1.2.jar' }
    jar_file_content_type { 'application/x-java-archive' }
    jar_file_file_size { 1024 }
    base_name ''
    categories { |a| [a.association(:category)] }
  end
end
