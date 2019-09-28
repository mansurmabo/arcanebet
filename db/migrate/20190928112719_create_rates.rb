# frozen_string_literal: true

class CreateRates < ActiveRecord::Migration[6.0]
  def change
    create_table :rates do |t|
      t.json :values
      t.belongs_to :request_option

      t.timestamps
    end
  end
end
