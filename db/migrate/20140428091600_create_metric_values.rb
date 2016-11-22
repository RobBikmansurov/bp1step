class CreateMetricValues < ActiveRecord::Migration
  def change
    create_table :metric_values do |t|
      t.references :metric, index: true
      t.datetime :dtime
      t.integer :value

      t.timestamps null: false
    end
  end
end
