class CreateBroadcastLists < ActiveRecord::Migration[5.0]
  def change
    create_table :broadcast_lists do |t|
      t.references :app, foreign_key: true
      t.references :batch_email_job, foreign_key: true
      t.references :email_list, foreign_key: true

      t.timestamps
    end
  end
end
