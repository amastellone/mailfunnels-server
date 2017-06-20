class CapturedHooksController < ApplicationController
  before_action :set_captured_hook, only: [:show, :update, :destroy]

  # GET /captured_hooks
  def index
    @captured_hooks = CapturedHook.all

    render json: @captured_hooks
  end

  # GET /captured_hooks/1
  def show
    render json: @captured_hook
  end

  # POST /captured_hooks
  def create
    @captured_hook = CapturedHook.new(captured_hook_params)

    if @captured_hook.save
      render json: @captured_hook, status: :created, location: @captured_hook
    else
      render json: @captured_hook.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /captured_hooks/1
  def update
    if @captured_hook.update(captured_hook_params)
      render json: @captured_hook
    else
      render json: @captured_hook.errors, status: :unprocessable_entity
    end
  end

  # DELETE /captured_hooks/1
  def destroy
    @captured_hook.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_captured_hook
      @captured_hook = CapturedHook.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def captured_hook_params
      params.require(:captured_hook).permit(:hook_id, :revenue, :subscriber_id, :app_id)
    end
end
