# frozen_string_literal: true

class ExchangesController < ApplicationController
  def dashboard
    @exchange = Exchange.new
    @currencies_options = Exchange.currencies
    @amount = params[:amount] || 1
    @base = params[:base] || 'EUR'
    @target = params[:target] || 'USD'
    @duration = params[:duration] || 1

    @historical_rates = historical_rates
    @today_rate = @historical_rates.last[:rate]
    @calculated_amount = calculate(@amount, @today_rate)
    @table_rates = rates_per_week
  end

  def index
    @exchanges = Exchange.all
  end

  def edit
    @exchange = Exchange.find(params[:id])
  end

  def create
    @exchange = Exchange.new(exchange_params)

    if @exchange.save
      redirect_to dashboard_exchanges_path(exchange_params.merge(params[:exchange].permit(:duration))), notice: 'Exchange was successfully created.'
    else
      redirect_to dashboard_exchanges_path, error: 'Exchange not created.'
    end
  end

  def update
    @exchange = Exchange.find(params[:id])

    if @exchange.update_attributes(exchange_params)
      redirect_to action: 'index', notice: 'Exchange was successfully updated.'
    else
      format.html { render action: 'edit' }
    end
  end

  def destroy
    @exchange = Exchange.find(params[:id])
    @exchange.destroy

    redirect_to exchanges_url
  end

  private

  def exchange_params
    params.require(:exchange).permit(:amount, :rate, :result, :base, :target)
  end

  def rates_per_week
    rates = []
    @historical_rates.each do |rate|
      week_number = rate[:week_number]
      next if rates.find { |r| r[:week_number] == week_number }

      part = @historical_rates.select { |r| r[:week_number] == week_number }
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
    duration_days = @duration.to_i * 7
    mapped_rates = []
    end_date = (Time.zone.now).strftime('%Y-%m-%d')
    start_date = (Time.zone.now - duration_days.days).strftime('%Y-%m-%d')

    rates = fetch_rates(start_date, end_date, @base)
    rates.each do |date, currencies|
      mapped_rates.push(date: date, rate: currencies[@target], week_number: Date.parse(date).strftime('%W'))
    end

    mapped_rates.sort_by { |r| r[:date] }
  end

  def calculate(amount, rate)
    (amount.to_f * rate.to_f).round(3)
  end

  def fetch_rates(start_date, end_date, base)
    exchange_rate = ExchangeRateApi.new(start_date: start_date, end_date: end_date, base: base)
    raise exchange_rate.historical.parsed_response['error'] if exchange_rate.historical.parsed_response['error']

    exchange_rate.historical.parsed_response['rates']
  end
end
