class AddFeildsToSubscribers < ActiveRecord::Migration[5.0]
  def change
    add_column :subscribers, :initial_ref_type, :integer
  end
end
