class CreateFunnels < ActiveRecord::Migration[5.0]
  def change
    create_table :funnels do |t|
      t.string :name
      t.string :description
      t.integer :numTriggers
      t.float :numRevenue

      t.timestamps
    end
  end
end
