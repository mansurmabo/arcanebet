# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Hello', type: :system do
  it 'it says hello' do
    visit '/'
    expect(page).to have_text('Exchange Rates')
  end
end
