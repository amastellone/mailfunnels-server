class FunnelsController < ApplicationController
  before_action :set_funnel, only: [:show, :update, :destroy]

  # GET /funnels
  def index

    if params.has_key? (:app_id)
      @funnels = Funnel.where(app_id: params[:app_id])
    end

    logger.info @funnels.to_json

    render json: @funnels
  end

  # GET /funnels/1
  def show
    render json: @funnel
  end

  # POST /funnels
  def create
    @funnel = Funnel.new(funnel_params)

    if @funnel.save
      render json: @funnel, status: :created, location: @funnel
    else
      render json: @funnel.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /funnels/1
  def update
    if @funnel.update(funnel_params)
      render json: @funnel
    else
      render json: @funnel.errors, status: :unprocessable_entity
    end
  end

  # DELETE /funnels/1
  def destroy
    @funnel.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_funnel
      @funnel = Funnel.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def funnel_params
      params.require(:funnel).permit(:name, :description, :num_emails_sent, :num_revenue, :active, :app_id, :trigger_id, :email_list_id)
    end
end
