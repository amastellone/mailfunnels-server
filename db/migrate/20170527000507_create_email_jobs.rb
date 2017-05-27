class CreateEmailJobs < ActiveRecord::Migration[5.0]
  def change
    create_table :email_jobs do |t|
      t.integer :subscriber_id
      t.integer :funnel_id
      t.integer :app_id
      t.boolean :executed

      t.timestamps
    end
  end
end
