class EmailListSubscribersController < ApplicationController
  before_action :set_email_list_subscriber, only: [:show, :update, :destroy]

  # GET /email_list_subscribers
  def index
    @email_list_subscribers = EmailListSubscriber.all

    render json: @email_list_subscribers
  end

  # GET /email_list_subscribers/1
  def show
    render json: @email_list_subscriber
  end

  # POST /email_list_subscribers
  def create
    @email_list_subscriber = EmailListSubscriber.new(email_list_subscriber_params)

    if @email_list_subscriber.save
      render json: @email_list_subscriber, status: :created, location: @email_list_subscriber
    else
      render json: @email_list_subscriber.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /email_list_subscribers/1
  def update
    if @email_list_subscriber.update(email_list_subscriber_params)
      render json: @email_list_subscriber
    else
      render json: @email_list_subscriber.errors, status: :unprocessable_entity
    end
  end

  # DELETE /email_list_subscribers/1
  def destroy
    @email_list_subscriber.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_email_list_subscriber
      @email_list_subscriber = EmailListSubscriber.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def email_list_subscriber_params
      params.require(:email_list_subscriber).permit(:app_id, :subscriber_id, :email_list_id)
    end
end
