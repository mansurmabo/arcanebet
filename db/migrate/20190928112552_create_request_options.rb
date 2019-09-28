# frozen_string_literal: true

class CreateRequestOptions < ActiveRecord::Migration[6.0]
  def change
    create_table :request_options do |t|
      t.date :start_date
      t.date :end_date
      t.string :base

      t.timestamps
    end
  end
end
