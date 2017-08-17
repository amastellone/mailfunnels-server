class AddAbandonedUrlToEmailJob < ActiveRecord::Migration[5.0]
  def change
    add_column :email_jobs, :abandoned_url, :string
  end
end
