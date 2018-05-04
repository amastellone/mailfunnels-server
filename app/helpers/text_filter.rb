module TextFilter
  def textilize(input)
    RedCloth.new(input).to_html
  end
end