# frozen_string_literal: true

class FixerApiService
  include HTTParty
  attr_accessor :base, :start_date, :end_date

  base_uri 'http://data.fixer.io/api'

  def initialize(options = {})
    @options = {
      query: {
        access_key: ENV['FIXER_ACCESS_KEY'],
        base: options[:base],
        start_date: options[:start_date],
        end_date: options[:end_date]
      }
    }
  end

  def latest
    self.class.get('/latest', @options)
  end

  def historical
    self.class.get('/timeseries', @options)
  end
end
