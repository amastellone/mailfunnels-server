class UnsubscribersController < ApplicationController
  before_action :set_unsubscriber, only: [:show, :update, :destroy]

  # GET /unsubscribers
  def index
    @unsubscribers = Unsubscriber.all

    render json: @unsubscribers
  end

  # GET /unsubscribers/1
  def show
    render json: @unsubscriber
  end

  # POST /unsubscribers
  def create
    @unsubscriber = Unsubscriber.new(unsubscriber_params)

    if @unsubscriber.save
      render json: @unsubscriber, status: :created, location: @unsubscriber
    else
      render json: @unsubscriber.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /unsubscribers/1
  def update
    if @unsubscriber.update(unsubscriber_params)
      render json: @unsubscriber
    else
      render json: @unsubscriber.errors, status: :unprocessable_entity
    end
  end

  # DELETE /unsubscribers/1
  def destroy
    @unsubscriber.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_unsubscriber
      @unsubscriber = Unsubscriber.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def unsubscriber_params
      params.require(:unsubscriber).permit(:first_name, :last_name, :email, :initial_ref_type, :app_id)
    end
end
