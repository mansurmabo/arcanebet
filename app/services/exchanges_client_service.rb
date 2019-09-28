# frozen_string_literal: true

class ExchangesClientService
  attr_accessor :type, :base, :target, :duration

  def initialize(options)
    @type = options[:type] || Exchange.apis[:exchange_rate]
    @base = options[:base] || 'EUR'
    @target = options[:target] || 'USD'
    @duration = options[:duration] || 1
  end

  def call
    chart_rates = historical_rates
    statistic_rates = rates_per_week(chart_rates)

    { chart_rates: historical_rates, statistic_rates: statistic_rates }
  end

  private

  def rates_per_week(chart_rates)
    rates = []
    chart_rates.each do |rate|
      week_number = rate[:week_number]
      next if skip_this(rates, week_number)

      week_rates = rates_by_week(chart_rates, week_number)
      rates.push(year: Date.parse(rate[:date]).year,
                 week_number: week_number,
                 avg_rate: week_avg_rate(week_rates),
                 highest: week_rates.max.round(3),
                 lowest: week_rates.min.round(3))
    end

    rates.reverse
  end

  def skip_this(rates, week_number)
    rates.find { |r| r[:week_number] == week_number }
  end

  def rates_by_week(chart_rates, week_number)
    chart_rates.select { |r| r[:week_number] == week_number }.map { |p| p[:rate] }
  end

  def week_avg_rate(week_rates)
    (week_rates.inject { |sum, el| sum + el }.to_f / week_rates.size).round(3)
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
    end_date = Time.zone.now.strftime('%Y-%m-%d')
    start_date = (Time.zone.now - duration_days.days).strftime('%Y-%m-%d')

    { start_date: start_date, end_date: end_date, base: @base }
  end

  def exchange_rate_api
    request = RequestOption.where(options).first
    request.present? ? request.rate.values : fetch_and_create_rates(ExchangeRatesApiService.new(options))
  end

  def fixer_api
    request = RequestOption.where(options).first
    request.present? ? request.rate.values : fetch_and_create_rates(FixerApiService.new(options))
  end

  def fetch_and_create_rates(exchange_rates)
    raise exchange_rates.historical.parsed_response['error'] if exchange_rates.historical.parsed_response['error']

    rates = save_rates(exchange_rates.historical.parsed_response['rates'])
    rates.values
  end

  def save_rates(rates)
    request_option = RequestOption.create(options)
    request_option.create_rate(values: rates)
  end
end
