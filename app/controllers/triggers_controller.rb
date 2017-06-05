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
  end

  # GET /triggers/1
  # GET /triggers/1.json
  def show
  end

  # GET /triggers/new
  def new
    @trigger = Trigger.new
  end

  # GET /triggers/1/edit
  def edit
  end

  # POST /triggers
  # POST /triggers.json
  def create
    @trigger = Trigger.new(trigger_params)

    respond_to do |format|
      if @trigger.save
        format.html {redirect_to @trigger, notice: 'Trigger was successfully created.'}
        format.json {render :show, status: :created, location: @trigger}
      else
        format.html {render :new}
        format.json {render json: @trigger.errors, status: :unprocessable_entity}
      end
    end
  end

  # PATCH/PUT /triggers/1
  # PATCH/PUT /triggers/1.json
  def update
    respond_to do |format|
      if @trigger.update(trigger_params)
        format.html {redirect_to @trigger, notice: 'Trigger was successfully updated.'}
        format.json {render :show, status: :ok, location: @trigger}
      else
        format.html {render :edit}
        format.json {render json: @trigger.errors, status: :unprocessable_entity}
      end
    end
  end

  # DELETE /triggers/1
  # DELETE /triggers/1.json
  def destroy
    @trigger.destroy
    respond_to do |format|
      format.html {redirect_to triggers_url, notice: 'Trigger was successfully destroyed.'}
      format.json {head :no_content}
    end
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
    trigger.num_triggered = 0
    trigger.num_emails_sent = 0
    logger.info("checking hook type")
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
          logger.info ("updated latest abandoned cart")
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
  # trigger_id: ID of the trigger
  #
  def ajax_process_abandoned_carts
    trigger = Trigger.find(params[:trigger_id])
    if trigger.last_abondoned_id == -1
      abandonedCarts = ShopifyAPI::Checkout.where(created_at_min: 2.weeks.ago, limit: 250)
    else
      abandonedCarts = ShopifyAPI::Checkout.where(since_id: trigger.last_abondoned_id, limit: 250)
    end

    if abandonedCarts.nil? == false
      logger.info("Looking for funnel found!")
      funnel = Funnel.where(app_id: trigger.app_id, trigger_id: trigger.id).first
      if funnel.nil? == false
        logger.info("Funnel found!")
        logger.info("looking for link")
        link = Link.where(funnel_id: funnel.id, start_link: 1).first
        if link.nil? == false
          logger.info("Link found!")
          logger.info("looking for Node")
          node = Node.where(id: link.to_node_id).first
          if node.nil? == false
            logger.info("Node Found")

            abandonedCarts.each do |abandonedCart|
              if abandonedCart.email.nil? == false

                logger.info("Checking if Subscriber exists")
                subscriber = Subscriber.where(app_id: app.id, email: abandonedCart.email).first
                if subscriber.nil? == true
                  logger.info("Subscriber does not exist, creating now!")
                  subscriber = Subscriber.create(app_id: trigger.app_id,
                                                 email: abandonedCart.email,
                                                 first_name: abandonedCart.billing_address.first_name,
                                                 last_name: abandonedCart.billing_address.last_name,
                                                 revenue: 0)
                else
                  logger.info("Subscriber exists!")
                end

                logger.info("Checking if subscriber is in email list")
                emailsub = EmailListSubscriber.where(app_id: trigger.app_id,
                                                     email_list_id: funnel.email_list_id,
                                                     subscriber_id: subscriber.id).first
                if emailsub.nil? == true
                  logger.info("Subscriber not in list, adding now!")
                  EmailListSubscriber.post('', {:app_id => trigger.app_id,
                                                :subscriber_id => subscriber.id,
                                                :email_list_id => funnel.email_list_id})
                else
                  logger.info("Subscriber is already in list!")
                end


                logger.info "Checking if job already exists"
                job = EmailJob.where(app_id: trigger.app_id,
                                     funnel_id: funnel.id,
                                     node_id: node.id,
                                     subscriber_id: subscriber.id).first
                if job.nil? == true
                  logger.info("Job does not exist creating now")
                  logger.info("rendering email template for job")
                  EmailJob.post('', {:app_id => trigger.app_id,
                                     :funnel_id => funnel.id,
                                     :subscriber_id => subscriber.id,
                                     :executed => false,
                                     :node_id => node.id,
                                     :email_template_id => node.email_template_id,
                                     :sent => 0})
                  logger.info("Sent Job to database!")
                else
                  logger.info("Email job already exists with these parameters")
                end

                puts "---created email job---"
                sleep 1
              end

            end
            logger.info("All Abandoned Carts Processed!")
          end
        end
      end
    end
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
