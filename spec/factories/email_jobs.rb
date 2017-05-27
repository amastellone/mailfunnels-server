FactoryGirl.define do
  factory :email_job do
    subscriber_id 1
    funnel_id 1
    app_id 1
    executed false
  end
end
