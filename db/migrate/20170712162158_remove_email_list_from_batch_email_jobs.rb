class RemoveEmailListFromBatchEmailJobs < ActiveRecord::Migration[5.0]
  def change
    remove_column :batch_email_jobs, :email_list_id
  end
end
