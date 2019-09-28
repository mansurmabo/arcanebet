# frozen_string_literal: true

class ExchangeRateApi
  include HTTParty
  attr_accessor :base, :start_date, :end_date

  base_uri 'http://api.exchangeratesapi.io'

  def initialize(options = {})
    @options = {
      query: {
        base: options[:base],
        start_at: options[:start_date],
        end_at: options[:end_date],
      }
    }
  end

  def latest
    self.class.get('/latest', @options)
  end

  def historical
    self.class.get('/history', @options)
  end
end
