module ExchangeRatesFixture
  CHART_RATES = [
      {:date => "2019-01-21", :rate => 1.1362, :week_number => "03"},
      {:date => "2019-01-22", :rate => 1.1354, :week_number => "03"},
      {:date => "2019-01-23", :rate => 1.1367, :week_number => "03"},
      {:date => "2019-01-24", :rate => 1.1341, :week_number => "03"},
      {:date => "2019-01-25", :rate => 1.1346, :week_number => "03"},
      {:date => "2019-01-28", :rate => 1.1418, :week_number => "04"},
      {:date => "2019-01-29", :rate => 1.1422, :week_number => "04"},
      {:date => "2019-01-30", :rate => 1.1429, :week_number => "04"}
  ]

  TABLE_RATES = [
      {
          :year => 2019,
          :week_number => "04",
          :avg_rate => 1.142,
          :highest => 1.143,
          :lowest => 1.142
      },
      {
          :year => 2019,
          :week_number => "03",
          :avg_rate => 1.135,
          :highest => 1.137,
          :lowest => 1.134
      }
  ]

end
