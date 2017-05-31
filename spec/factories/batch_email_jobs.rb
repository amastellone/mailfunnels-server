FactoryGirl.define do
  factory :batch_email_job do
    name "MyString"
    description "MyText"
    app nil
    email_list nil
    email_template nil
  end
end
