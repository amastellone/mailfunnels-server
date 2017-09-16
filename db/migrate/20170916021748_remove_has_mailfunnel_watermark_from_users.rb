class RemoveHasMailfunnelWatermarkFromUsers < ActiveRecord::Migration[5.0]
  def change
    remove_column :users, :has_mailfunnel_watermark
  end
end
