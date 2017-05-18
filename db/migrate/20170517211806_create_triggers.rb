class CreateTriggers < ActiveRecord::Migration[5.0]
  def change
    create_table :triggers do |t|
      t.string :name
      t.string :description
      t.string :emailSubject
      t.string :emailContent
      t.integer :num_times_triggered
      t.integer :num_emails_sent
      t.integer :delayTime

      t.timestamps
    end
  end
end
