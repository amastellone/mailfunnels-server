class AddDefaultTrueToHasMailfunnelsWatermark < ActiveRecord::Migration[5.0]
  def up
    change_column :users, :has_mailfunnel_watermark, :boolean, default: true
  end

  def down
    change_column :users, :has_mailfunnel_watermark, :boolean, default: nil
  end
end
