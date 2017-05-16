class FunnelController < ShopifyApp::AuthenticatedController


  # PAGE RENDER FUNCTION
  # --------------------
  # Renders the Funnels Page which lists all the
  # funnels and their content
  #
  def index
    @funnels = FunnelModel.all
  end

  # PAGE RENDER FUNCTION
  # --------------------
  # Renders the Edit Funnel Page which allows
  # user to edit the funnel they selected
  #
  # PARAMETERS
  # ----------
  # id: the id of the funnel being edited
  #
  #
  def edit_funnel

  end

end
