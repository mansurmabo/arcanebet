# frozen_string_literal: true

class ExchangesClientService
  attr_accessor :type, :base, :target, :duration

  def initialize(options)
    @type = options[:type]
    @base = options[:base]
    @target = options[:target]
    @duration = options[:duration]
  end

  def call
    chart_rates = historical_rates
    statistic_rates = rates_per_week(chart_rates)

    {chart_rates: historical_rates, statistic_rates: statistic_rates}
  end

  private

  def rates_per_week(chart_rates)
    rates = []
    chart_rates.each do |rate|
      week_number = rate[:week_number]
      next if rates.find { |r| r[:week_number] == week_number }

      part = chart_rates.select { |r| r[:week_number] == week_number }
      part_rates = part.map { |p| p[:rate] }
      avg_rate = part_rates.inject { |sum, el| sum + el }.to_f / part_rates.size
      rates.push(
          year: Date.parse(rate[:date]).year,
          week_number: week_number,
          avg_rate: avg_rate.round(3),
          highest: part_rates.max.round(3),
          lowest: part_rates.min.round(3)
      )
    end

    rates.reverse
  end

  def historical_rates
    rates = fetch_api_rates

    mapped_rates = []
    rates.each do |date, currencies|
      mapped_rates.push(date: date, rate: currencies[@target], week_number: Date.parse(date).strftime('%W'))
    end
    mapped_rates.sort_by { |r| r[:date] }
  end

  def fetch_api_rates
    return exchange_rate_api if @type == :exchange_rates
    return fixer_api if @type == :fixer_api

    raise 'Please send correct api type.'
  end

  def options
    duration_days = @duration.to_i * 7
    end_date = (Time.zone.now).strftime('%Y-%m-%d')
    start_date = (Time.zone.now - duration_days.days).strftime('%Y-%m-%d')

    {start_date: start_date, end_date: end_date, base: @base}
  end

  def exchange_rate_api
    exchange_rates = ExchangeRatesApiService.new(options)
    raise exchange_rates.historical.parsed_response['error'] if exchange_rates.historical.parsed_response['error']

    exchange_rates.historical.parsed_response['rates']
  end

  def fixer_api
    exchange_rates = FixerApiService.new(options)
    raise exchange_rates.historical.parsed_response['error'] if exchange_rates.historical.parsed_response['error']

    exchange_rates.historical.parsed_response['rates']
  end
end
