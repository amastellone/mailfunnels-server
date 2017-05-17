require 'rails_helper'

RSpec.describe "funnels/show", type: :view do
  before(:each) do
    @funnel = assign(:funnel, Funnel.create!(
      :name => "Name",
      :description => "Description",
      :numTriggers => 2,
      :numRevenue => 3.5
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Name/)
    expect(rendered).to match(/Description/)
    expect(rendered).to match(/2/)
    expect(rendered).to match(/3.5/)
  end
end
