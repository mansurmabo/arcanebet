# frozen_string_literal: true

require 'rails_helper'
require 'fixtures/exchange_rates_fixture'

describe ExchangesClientService do
  describe 'exchange_rates_api' do
    it 'call' do
      api_response = response_stub('exchange_client_historical')

      allow_any_instance_of(ExchangesClientService).to receive(:fetch_api_rates).and_return(api_response)
      client = ExchangesClientService.new(type: Exchange.apis[:exchange_rate], base: 'EUR', target: 'USD', duration: 1)
      response = client.call

      expect(response[:chart_rates]).to eq(ExchangeRatesFixture::CHART_RATES)
      expect(response[:statistic_rates]).to eq(ExchangeRatesFixture::TABLE_RATES)
    end
  end
end
