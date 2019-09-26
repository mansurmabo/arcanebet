const Chart = require('chart.js');

$(document).ready(function () {
  const ctx = document.getElementById('myChart').getContext('2d');
  const dataEl = document.getElementById('chart_data')
  const data = JSON.parse(dataEl.dataset['historicalRates'])

  const pointBackgroundColors = [];

  const myChart = new Chart(ctx, {
    type: 'line',
    data: {
      labels: data.map(d => d.date),
      datasets: [
        {
          label: '# of Rate',
          data: data.map(d => d.rate),
          pointBackgroundColor: pointBackgroundColors,
          backgroundColor: [
            'rgba(42,104,255,0.2)',
          ],
          borderColor: [
            'rgb(157,172,191)',
          ],
          borderWidth: 1
        }
      ]
    },
    options: {
      responsive: false,
      lineTension: 0,
    }
  });

  const rates = myChart.data.datasets[0].data;
  const minRate = Math.min(...rates);
  const maxRate = Math.max(...rates);
  rates.forEach(rate => {
    if (rate === minRate) {
      pointBackgroundColors.push("#cd1915");
    } else if (rate === maxRate) {
      pointBackgroundColors.push("#35e923");
    } else {
      pointBackgroundColors.push("#a3d0f5");
    }
  })

  myChart.update();
});
