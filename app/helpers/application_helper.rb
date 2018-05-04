module ApplicationHelper

  def liquidize(content, arguments)
    RedCloth.new(Liquid::Template.parse(content).render(arguments, :filters => [LiquidFilter])).to_html
  end

end
