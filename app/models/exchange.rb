# frozen_string_literal: true

class Exchange < ApplicationRecord
  enum api: { exchange_rate: :exchange_rates, fixer: :fixer }

  def self.currencies
    %w[AUD BGN BRL CAD CHF CNY CZK DKK EUR GBP HKD HRK HUF IDR ILS INR
       JPY KRW MXN MYR NOK NZD PHP PLN RON RUB SEK SGD THB TRY USD ZAR]
  end
end
