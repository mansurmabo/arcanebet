require 'rails_helper.rb'

describe ExchangeRateApi do
  describe 'latest' do
    it 'successfully' do
      success_response = response_stub('exchange_api_latest')
      allow_any_instance_of(ExchangeRateApi).to receive(:latest).and_return(success_response)
      api = ExchangeRateApi.new()
      response = api.latest

      expect(response).to eq(success_response)
    end
  end

  describe 'historical' do
    it 'successfuly' do
      success_response = response_stub('exchange_api_historical')
      allow_any_instance_of(ExchangeRateApi).to receive(:historical).and_return(success_response)
      api = ExchangeRateApi.new(start_date: '2019-01-20', end_date: '2019-01-30', base: 'EUR')
      response = api.historical

      expect(response).to eq(success_response)
    end

    it 'missing start date' do
      missing_start_response = response_stub('exchange_api_historical_missing_start')
      allow_any_instance_of(ExchangeRateApi).to receive(:historical).and_return(missing_start_response)
      api = ExchangeRateApi.new()
      response = api.historical

      expect(response['error']).to eq('missing start_at parameter')
    end

    it 'missing end date' do
      missing_end_response = response_stub('exchange_api_historical_missing_end')
      allow_any_instance_of(ExchangeRateApi).to receive(:historical).and_return(missing_end_response)
      api = ExchangeRateApi.new(start_date: '2019-01-20')
      response = api.historical

      expect(response['error']).to eq('missing end_at parameter')
    end

  end
end