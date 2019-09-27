class CreateExchanges < ActiveRecord::Migration[6.0]
  def change
    create_table :exchanges do |t|
      t.decimal :amount
      t.decimal :rate
      t.decimal :result
      t.string :base
      t.string :target

      t.timestamps
    end
  end
end
