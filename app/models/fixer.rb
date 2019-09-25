class Fixer
  include HTTParty
  attr_accessor :base, :target, :date

  ACCESS_KEY = ENV['FIXER_ACCESS_KEY']
  base_uri 'http://data.fixer.io/api/'

  def initialize(options = {})
    @date = options[:date] || Time.zone.now.strftime('%F')
    @options = {
        query: {
          access_key: ACCESS_KEY,
          base: options[:base] || 'EUR',
          symbols: Rate.currencies.join(', ')
        }
    }
  end

  def historical
    self.class.get(@date, @options)
  end
end