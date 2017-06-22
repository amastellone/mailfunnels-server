class TriggersController < ShopifyApp::AuthenticatedController
  before_action :set_trigger, only: [:show, :edit, :update, :destroy]

  # GET /triggers
  # GET /triggers.json
  def index

    # Get the current app id
    @app = MailfunnelsUtil.get_app

    # Get All Triggers
    @triggers = Trigger.where(app_id: @app.id)

    # Get All Lists
    @lists = EmailList.where(app_id: @app.id)

    # Get All Hooks
    @hookslist = Hook.all

    # Get All Products on the Current Store
    @products = ShopifyAPI::Product.all

  end


  # USED WITH AJAX
  # Creates a new trigger model
  #
  # PARAMETERS
  #---------------------
  # name: Name of new trigger
  # description: Description of new trigger
  # app_id: ID of the Current App
  # hook_id: ID of the Hook
  #
  #
  def ajax_create_trigger

    # Create new Trigger model
    trigger = Trigger.new

    # Update fields in Trigger model
    trigger.app_id = params[:app_id]
    trigger.hook_id = params[:hook_id]
    trigger.name = params[:name]
    trigger.description = params[:description]
    trigger.product_id = params[:product_id]
    trigger.num_triggered = 0
    trigger.num_emails_sent = 0
    trigger.last_abondoned_id = -1


    hook = Hook.where(id: params[:hook_id]).first
    if hook.nil? == false
      logger.info("hook found!")
      if hook.identifier == 'abandoned_checkout'
        logger.info("getting latest cart Id")
        latestCart = ShopifyAPI::Checkout.find(:all).last
        if latestCart.nil? == false
          trigger.last_abondoned_id = latestCart.id
          logger.info ("updated latest abandoned cart")
        else
          trigger.last_abondoned_id = -1
          logger.info ("no abandoned carts yet")
        end

      end
    end


    # Save Trigger to DB
    saveResponse = trigger.save!

    # Check to see if the job was saved and return correct JSON response
    if saveResponse
      final_json = JSON.pretty_generate(result = {
          'status' => true
      })
    else
      final_json = JSON.pretty_generate(result = {
          'status' => false
      })
    end

    # Return JSON response
    render json: final_json


  end


  # USED WITH AJAX
  # --------------
  # Gets all the new abandoned carts and adds them to the funnel
  #
  #
  # PARAMETERS
  # ----------
  # none
  #
  def ajax_process_abandoned_carts

    app = MailfunnelsUtil.get_app
    shop = Shop.find_by(shopify_domain: app.name)

    ProcessCheckoutsJob.perform_later(app.id, shop)

    final_json = JSON.pretty_generate(result = {
        'abandoned_cart_count' => 5
    })

    render json: final_json
  end


  private
  # Use callbacks to share common setup or constraints between actions.
  def set_trigger
    @trigger = Trigger.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def trigger_params
    params.require(:trigger).permit(:name, :description, :num_triggered, :num_emails_sent, :hook_id, :app_id)
  end

end
