class ExchangesController < ApplicationController
  def index
    @currencies_options = Rate.currencies
    @base = params['/exchanges']['base'] || 'EUR'
    @target = params['/exchanges']['target'] || 'USD'
    @amount = params['/exchanges']['amount'] || 1
    @duration = params['/exchanges']['duration'] || 1

    date = (Time.zone.now).strftime('%Y-%m-%d')

    @rate_value = fetch_by_target(date, @base, @target)
    @result = calculate(@amount, @rate_value)
  end

  def calculate(amount, rate)
     amount.to_f * rate.to_f
  end

  def fetch_by_target(date, base, target)
    rate = local_rate(date, base)

    if rate.present?
      rate.rates[target]
    else
      created_rate = fetch_and_save_rate(date, base)
      created_rate.rates[target]
    end
  end

  def local_rate(date, base)
    Rate.where(date: date, base: base).first
  end

  def fetch_and_save_rate(date, base)
    fixer = Fixer.new(date: date, base: base)
    if fixer.historical.parsed_response['success']
      parsed_rates = fixer.historical.parsed_response['rates']
      Rate.create(date: date, base: base, rates: parsed_rates)
    else
      raise fixer.historical.parsed_response['error']['type']
    end
  end

end
