require 'rails_helper'

RSpec.describe "funnels/new", type: :view do
  before(:each) do
    assign(:funnel, Funnel.new(
      :name => "MyString",
      :description => "MyString",
      :numTriggers => 1,
      :numRevenue => 1.5
    ))
  end

  it "renders new funnel form" do
    render

    assert_select "form[action=?][method=?]", funnels_path, "post" do

      assert_select "input#funnel_name[name=?]", "funnel[name]"

      assert_select "input#funnel_description[name=?]", "funnel[description]"

      assert_select "input#funnel_numTriggers[name=?]", "funnel[numTriggers]"

      assert_select "input#funnel_numRevenue[name=?]", "funnel[numRevenue]"
    end
  end
end
