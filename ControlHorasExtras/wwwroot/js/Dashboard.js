document.addEventListener('DOMContentLoaded', () => {
    // Datos iniciales pasados desde el servidor
    const { horas50, horas100, gasto50, gasto100, meses, horas50Historico, horas100Historico } = window.dashboardData;

    let horasMesChart, gastoMesChart, horasHistoricasChart;

    // 1. Inicializar gráficos
    function initCharts() {
        // Gráfico de horas realizadas
        const horasMesChartCanvas = document.getElementById('horasMesChart').getContext('2d');
        horasMesChart = new Chart(horasMesChartCanvas, {
            type: 'bar',
            data: {
                labels: ['50%', '100%'],
                datasets: [{
                    label: 'Horas Realizadas',
                    data: [horas50, horas100],
                    backgroundColor: ['rgba(75, 192, 192, 0.6)', 'rgba(255, 159, 64, 0.6)']
                }]
            },
            options: getBarChartOptions(),
            plugins: [ChartDataLabels]
        });

        // Gráfico de gasto mensual
        const gastoMesChartCanvas = document.getElementById('gastoMesChart').getContext('2d');
        gastoMesChart = new Chart(gastoMesChartCanvas, {
            type: 'bar',
            data: {
                labels: ['Gasto 50%', 'Gasto 100%'],
                datasets: [{
                    label: 'Gasto Mensual',
                    data: [gasto50, gasto100],
                    backgroundColor: ['rgba(75, 192, 192, 0.6)', 'rgba(255, 159, 64, 0.6)']
                }]
            },
            options: getBarChartOptions(true),
            plugins: [ChartDataLabels]
        });

        // Gráfico de histórico
        const horasHistoricasChartCanvas = document.getElementById('horasHistoricasChart').getContext('2d');
        horasHistoricasChart = new Chart(horasHistoricasChartCanvas, {
            type: 'line',
            data: {
                labels: meses,
                datasets: [
                    { label: 'Horas 50%', data: horas50Historico, borderColor: 'rgba(75, 192, 192, 1)', backgroundColor: 'rgba(75, 192, 192, 0.2)', fill: true },
                    { label: 'Horas 100%', data: horas100Historico, borderColor: 'rgba(255, 99, 132, 1)', backgroundColor: 'rgba(255, 99, 132, 0.2)', fill: true }
                ]
            },
            options: { responsive: true }
        });
    }

    // 2. Opciones para los gráficos
    function getBarChartOptions(isCurrency = false) {
        return {
            responsive: true,
            plugins: {
                legend: { display: false },
                datalabels: {
                    anchor: 'end',
                    align: 'top',
                    formatter: isCurrency
                        ? value => value.toLocaleString('es-AR', { style: 'currency', currency: 'ARS' })
                        : Math.round,
                    font: { weight: 'bold', size: 12 }
                }
            },
            scales: {
                y: { beginAtZero: true, ticks: { padding: 10 } },
                x: { ticks: { padding: 20 } }
            },
            layout: { padding: { top: 20 } }
        };
    }

    // 3. Actualización de los gráficos
    function updateCharts(data) {
        const horas50 = parseFloat(data.horas50) || 0;
        const horas100 = parseFloat(data.horas100) || 0;
        const gasto50 = parseFloat(data.gasto50) || 0;
        const gasto100 = parseFloat(data.gasto100) || 0;
        const historico50 = data.historico50.map(h => parseFloat(h) || 0);
        const historico100 = data.historico100.map(h => parseFloat(h) || 0);

        // Actualizar gráfico de horas
        horasMesChart.data.datasets[0].data = [horas50, horas100];
        horasMesChart.update();

        // Actualizar gráfico de gasto
        gastoMesChart.data.datasets[0].data = [gasto50, gasto100];
        gastoMesChart.update();

        // Actualizar gráfico histórico
        horasHistoricasChart.data.datasets[0].data = historico50;
        horasHistoricasChart.data.datasets[1].data = historico100;
        horasHistoricasChart.update();
    }

    // 4. Manejador del filtro de áreas
    function handleAreaFilterChange() {
        const areaFilter = document.getElementById('areaFilter');
        areaFilter?.addEventListener('change', () => {
            const areaId = areaFilter.value;

            fetch(`/Dashboard/GetChartData?areaId=${areaId}`)
                .then(response => response.json())
                .then(updateCharts)
                .catch(error => console.error('Error al cargar los datos del gráfico:', error));
        });
    }

    // 5. Inicializar lógica de carga de horas
    function initFormLogic() {
        const formHoras = document.getElementById('formHoras');
        const btnCargarHoras = document.getElementById('btnCargarHoras');

        btnCargarHoras?.addEventListener('click', () => {
            formHoras.classList.toggle('hidden');
            btnCargarHoras.classList.toggle('hidden');
        });

        formHoras?.addEventListener('submit', (e) => {
            e.preventDefault();
            const formData = new FormData(formHoras);

            fetch('/Overtime/Create', {
                method: 'POST',
                body: formData,
                headers: {
                    'X-Requested-With': 'XMLHttpRequest',
                    'RequestVerificationToken': document.querySelector('input[name="__RequestVerificationToken"]').value
                }
            })
                .then(response => response.json())
                .then(data => {
                    if (data.success) location.reload();
                    else alert(data.message);
                })
                .catch(console.error);
        });
    }

    // 6. Ejecutar inicializaciones
    initCharts();
    handleAreaFilterChange();
    initFormLogic();
});
