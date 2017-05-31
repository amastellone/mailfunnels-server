class BatchEmailJobsController < ApplicationController
  before_action :set_batch_email_job, only: [:show, :update, :destroy]

  # GET /batch_email_jobs
  def index
    @batch_email_jobs = SendBatchEmailJob.all

    render json: @batch_email_jobs
  end

  # GET /batch_email_jobs/1
  def show
    render json: @batch_email_job
  end

  # POST /batch_email_jobs
  def create
    @batch_email_job = SendBatchEmailJob.new(batch_email_job_params)

    if @batch_email_job.save
      render json: @batch_email_job, status: :created, location: @batch_email_job
    else
      render json: @batch_email_job.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /batch_email_jobs/1
  def update
    if @batch_email_job.update(batch_email_job_params)
      render json: @batch_email_job
    else
      render json: @batch_email_job.errors, status: :unprocessable_entity
    end
  end

  # DELETE /batch_email_jobs/1
  def destroy
    @batch_email_job.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_batch_email_job
      @batch_email_job = SendBatchEmailJob.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def batch_email_job_params
      params.require(:batch_email_job).permit(:name, :description, :app_id, :email_list_id, :email_template_id)
    end
end
