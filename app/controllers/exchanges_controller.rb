class ExchangesController < ApplicationController
  def index
    @currencies_options = Rate.currencies
    @base = params['/exchanges'] && params['/exchanges']['base'] || 'EUR'
    @target = params['/exchanges'] && params['/exchanges']['target'] || 'USD'
    @amount = params['/exchanges'] && params['/exchanges']['amount'] || 1
    @duration = params['/exchanges'] && params['/exchanges']['duration'] || 1

    @historical_rates = historical_rates
    @today_rate = @historical_rates.last[:rate]
    @calculated_amount = calculate(@amount, @today_rate)

    @table_rates = rates_per_week
  end

  def create

  end

  private

  def rates_per_week
    rates = []
    @historical_rates.each do |rate|
      week_number = rate[:week_number]
      next if rates.find { |r| r[:week_number] == week_number }

      part = @historical_rates.select { |r| r[:week_number] == week_number }
      part_rates = part.map { |p| p[:rate] }
      avg_rate = part_rates.inject { |sum, el| sum + el }.to_f / part_rates.size
      rates.push(
          {
              year: Date.parse(rate[:date]).year,
              week_number: week_number,
              avg_rate: avg_rate.round(3),
              highest: part_rates.max,
              lowest: part_rates.min
          }
      )
    end

    rates.reverse
  end

  def historical_rates
    duration_days = @duration.to_i * 7
    mapped_rates = []
    end_date = (Time.zone.now).strftime('%Y-%m-%d')
    start_date = (Time.zone.now - duration_days.days).strftime('%Y-%m-%d')

    rates = fetch_rates(start_date, end_date, @base)
    rates.each do |date, currencies|
      mapped_rates.push({date: date, rate: currencies[@target], week_number: Date.parse(date).strftime('%W')})
    end

    mapped_rates.sort_by { |r| r[:date] }
  end

  def calculate(amount, rate)
    (amount.to_f * rate.to_f).round(3)
  end

  def fetch_rates(start_date, end_date, base)
    fixer = ExchangeRateApi.new(start_date: start_date, end_date: end_date, base: base)

    if fixer.historical.parsed_response['error']
      raise fixer.historical.parsed_response['error']
    end

    fixer.historical.parsed_response['rates']
  end

end
