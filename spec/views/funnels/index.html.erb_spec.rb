require 'rails_helper'

RSpec.describe "funnels/index", type: :view do
  before(:each) do
    assign(:funnels, [
      Funnel.create!(
        :name => "Name",
        :description => "Description",
        :numTriggers => 2,
        :numRevenue => 3.5
      ),
      Funnel.create!(
        :name => "Name",
        :description => "Description",
        :numTriggers => 2,
        :numRevenue => 3.5
      )
    ])
  end

  it "renders a list of funnels" do
    render
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => "Description".to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
    assert_select "tr>td", :text => 3.5.to_s, :count => 2
  end
end
