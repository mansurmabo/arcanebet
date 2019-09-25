class CreateRates < ActiveRecord::Migration[6.0]
  def change
    create_table :rates do |t|
      t.date :date
      t.string :base
      t.json :rates
    end
  end
end
