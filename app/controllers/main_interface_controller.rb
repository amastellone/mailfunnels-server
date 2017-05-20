class MainInterfaceController < ShopifyApp::AuthenticatedController
  before_action :set_campaign_id, only: [:edit_campaign]

  def index
    app = BluehelmetUtil.get_app
    logger.info("App-Name: " + BluehelmetUtil.get_app_name)
  end

  def form_page
    if request.post?
      if params[:name].present?
        flash[:notice] = "Created #{ params[:colour] } unicorn: #{ params[:name] }."
      else
        flash[:error] = "Name must be set."
      end
    end
  end

  def pagination
    @total_pages = 3
    @page = (params[:page].presence || 1).to_i
    @previous_page = "/pagination?page=#{ @page - 1 }" if @page > 1
    @next_page = "/pagination?page=#{ @page + 1 }" if @page < @total_pages
  end

end
