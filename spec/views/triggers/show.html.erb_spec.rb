require 'rails_helper'

RSpec.describe "triggers/show", type: :view do
  before(:each) do
    @trigger = assign(:trigger, Trigger.create!(
      :name => "Name",
      :description => "Description",
      :emailSubject => "Email Subject",
      :emailContent => "Email Content",
      :num_times_triggered => 2,
      :num_emails_sent => 3,
      :delayTime => 4
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Name/)
    expect(rendered).to match(/Description/)
    expect(rendered).to match(/Email Subject/)
    expect(rendered).to match(/Email Content/)
    expect(rendered).to match(/2/)
    expect(rendered).to match(/3/)
    expect(rendered).to match(/4/)
  end
end
