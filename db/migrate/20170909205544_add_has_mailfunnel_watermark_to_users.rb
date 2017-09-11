class AddHasMailfunnelWatermarkToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :has_mailfunnel_watermark, :boolean
  end
end
