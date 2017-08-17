class AddLastAbandondedUrlToSubscriber < ActiveRecord::Migration[5.0]
  def change
    add_column :subscribers, :abandoned_url, :string
  end
end
