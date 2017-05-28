class SubscribersController < ApplicationController
  before_action :set_subscriber, only: [:show, :update, :destroy]


  # PAGE RENDER FUNCTION
  # --------------------
  # Removes a subscribers from an app and renders
  # an unsubscribe page that informs subscribers that
  # is removed from the email list
  #
  # PARAMETERS
  # ----------
  # subscriber_id: ID of the Subscriber we are removing
  #
  def unsubscribe_page

    # Get the Subscriber from the DB
    subscriber = Subscriber.where(id: params[:subscriber_id]).first


    # If the subscriber is already removed
    if subscriber.nil?

      # Render the Already Unsubscribed Page
      render html: "You have already been unsibscribed"

    else

      # Destroy the Subscriber From DB
      subscriber.destroy

      # Render the Unsubscribe Page
      render html: "You have been unsibscribed"

    end

  end



  # GET /subscribers
  def index
    @subscribers = Subscriber.all

    render json: @subscribers
  end

  # GET /subscribers/1
  def show
    render json: @subscriber
  end

  # POST /subscribers
  def create
    @subscriber = Subscriber.new(subscriber_params)

    if @subscriber.save
      render json: @subscriber, status: :created, location: @subscriber
    else
      render json: @subscriber.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /subscribers/1
  def update
    if @subscriber.update(subscriber_params)
      render json: @subscriber
    else
      render json: @subscriber.errors, status: :unprocessable_entity
    end
  end

  # DELETE /subscribers/1
  def destroy
    @subscriber.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_subscriber
      @subscriber = Subscriber.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def subscriber_params
      params.require(:subscribers).permit(:first_name, :last_name, :email, :app_id)
    end
end
