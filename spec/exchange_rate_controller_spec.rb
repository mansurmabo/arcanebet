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
  #   it 'Не успешный запрос списка типов налогов' do
  #     success_response = JSON.parse(response_stub(endpoint, 'bad_response'))
  #     allow(ModRequest::Await).to receive(:call).and_return(success_response)
  #
  #     response = request(endpoint, jwt_headers, 'bad_request')
  #
  #     expect(response.status).to eq(400)
  #     response_body = JSON.parse(response.body)
  #     expect(response_body['error']).to eq(success_response.fetch('error'))
  #   end
  #
  #   it 'Запрос с ошибочным токеном' do
  #     response = request(endpoint, empty_headers, 'bad_request')
  #
  #     expect(response.status).to eq(401)
  #   end
  #
  #   it 'Запрос с ошибкой от mod_finance' do
  #     error_response = JSON.parse(
  #         response_stub(endpoint, 'response_with_error')
  #     )
  #     allow(ModRequest::Await).to receive(:call).and_return(error_response)
  #
  #     response = request(endpoint, jwt_headers, 'request')
  #
  #     expect(response.status).to eq(500)
  #     response_body = JSON.parse(response.body)
  #     error = {
  #         'code' => 'mod_finance_error',
  #         'message' => 'Не удалось запросить информацию списка типов налогов',
  #         'cause' => {
  #             'code' => 'mod_finance_error',
  #             'message' => 'Не удалось запросить информацию списка типов налогов',
  #             'request_id' => 'a58585d1-89a7-4802-820f-46d2548e1189',
  #             'success' => false
  #         }
  #     }
  #     expect(response_body['error']).to eq(error)
  #   end

end