require 'rails_helper'

RSpec.describe "funnels/edit", type: :view do
  before(:each) do
    @funnel = assign(:funnel, Funnel.create!(
      :name => "MyString",
      :description => "MyString",
      :numTriggers => 1,
      :numRevenue => 1.5
    ))
  end

  it "renders the edit funnel form" do
    render

    assert_select "form[action=?][method=?]", funnel_path(@funnel), "post" do

      assert_select "input#funnel_name[name=?]", "funnel[name]"

      assert_select "input#funnel_description[name=?]", "funnel[description]"

      assert_select "input#funnel_numTriggers[name=?]", "funnel[numTriggers]"

      assert_select "input#funnel_numRevenue[name=?]", "funnel[numRevenue]"
    end
  end
end
