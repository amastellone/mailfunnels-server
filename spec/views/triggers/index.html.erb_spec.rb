require 'rails_helper'

RSpec.describe "triggers/index", type: :view do
  before(:each) do
    assign(:triggers, [
      Trigger.create!(
        :name => "Name",
        :description => "Description",
        :emailSubject => "Email Subject",
        :emailContent => "Email Content",
        :num_times_triggered => 2,
        :num_emails_sent => 3,
        :delayTime => 4
      ),
      Trigger.create!(
        :name => "Name",
        :description => "Description",
        :emailSubject => "Email Subject",
        :emailContent => "Email Content",
        :num_times_triggered => 2,
        :num_emails_sent => 3,
        :delayTime => 4
      )
    ])
  end

  it "renders a list of triggers" do
    render
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => "Description".to_s, :count => 2
    assert_select "tr>td", :text => "Email Subject".to_s, :count => 2
    assert_select "tr>td", :text => "Email Content".to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
    assert_select "tr>td", :text => 3.to_s, :count => 2
    assert_select "tr>td", :text => 4.to_s, :count => 2
  end
end
