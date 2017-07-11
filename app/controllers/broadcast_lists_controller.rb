class BroadcastListsController < ApplicationController
  before_action :set_broadcast_list, only: [:show, :update, :destroy]

  # GET /broadcast_lists
  def index
    @broadcast_lists = BroadcastList.all

    render json: @broadcast_lists
  end

  # GET /broadcast_lists/1
  def show
    render json: @broadcast_list
  end

  # POST /broadcast_lists
  def create
    @broadcast_list = BroadcastList.new(broadcast_list_params)

    if @broadcast_list.save
      render json: @broadcast_list, status: :created, location: @broadcast_list
    else
      render json: @broadcast_list.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /broadcast_lists/1
  def update
    if @broadcast_list.update(broadcast_list_params)
      render json: @broadcast_list
    else
      render json: @broadcast_list.errors, status: :unprocessable_entity
    end
  end

  # DELETE /broadcast_lists/1
  def destroy
    @broadcast_list.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_broadcast_list
      @broadcast_list = BroadcastList.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def broadcast_list_params
      params.require(:broadcast_list).permit(:app_id, :batch_email_job_id, :email_list_id)
    end
end
