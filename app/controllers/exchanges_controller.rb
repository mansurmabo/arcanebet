# frozen_string_literal: true

class ExchangesController < ApplicationController
  def dashboard
    @exchange = Exchange.new
    @currencies_options = Exchange.currencies
    @amount = params[:amount] || 1
    @base = params[:base] || 'EUR'
    @target = params[:target] || 'USD'
    @duration = params[:duration] || 1
    rates = fetch_rates
    @historical_rates = rates[:chart_rates]
    @today_rate = @historical_rates.last[:rate]
    @calculated_amount = multiply(@amount, @today_rate)
    @table_rates = rates[:statistic_rates]
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
      redirect_to dashboard_exchanges_path(exchange_params.merge(params[:exchange].permit(:duration)))
    else
      redirect_to dashboard_exchanges_path
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

  def fetch_rates
    client = ExchangesClientService.new(type: Exchange.apis[:exchange_rate],
                                        base: @base,
                                        target: @target,
                                        duration: @duration)
    client.call
  end

  def multiply(amount, rate)
    (amount.to_f * rate.to_f).round(3)
  end
end
