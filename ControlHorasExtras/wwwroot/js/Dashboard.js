const formHoras = document.getElementById('formHoras');
const btnCargarHoras = document.getElementById('btnCargarHoras');
let empleadoId = null;

// Mostrar y ocultar el formulario de carga
function cargarFormulario() {
    formHoras.classList.toggle('hidden');
    btnCargarHoras.classList.toggle('hidden');
    if (!formHoras.classList.contains('hidden')) {
        fetch('/Overtime/Create')
            .then(response => response.json())
            .then(data => cargarOpcionesFormulario(data))
            .catch(error => console.error('Error al cargar los datos:', error));
    }
}

// Cargar empleados en el formulario
function cargarOpcionesFormulario(data) {
    const empleadoSelect = document.getElementById('empleado');
    empleadoSelect.innerHTML = '<option value="" selected disabled>Seleccione un empleado</option>';
    data.empleados.forEach(empleado => {
        empleadoSelect.innerHTML += `
                <option value="${empleado.empleadoId}"
                        data-area-id="${empleado.areaId}"
                        data-area-nombre="${empleado.areaNombre}"
                        data-secretaria-id="${empleado.secretariaId}"
                        data-secretaria-nombre="${empleado.secretariaNombre}">
                    ${empleado.legajo} - ${empleado.nombre} ${empleado.apellido}
                </option>`;
    });
}

// Actualizar área y secretaría en el formulario
function actualizarAreaYSecretaria() {
    const empleadoSelect = document.getElementById('empleado');
    const selectedOption = empleadoSelect.options[empleadoSelect.selectedIndex];
    empleadoId = selectedOption.value;

    const areaId = selectedOption.getAttribute('data-area-id') || '';
    const areaNombre = selectedOption.getAttribute('data-area-nombre') || 'Sin Área';
    const secretariaId = selectedOption.getAttribute('data-secretaria-id') || '';
    const secretariaNombre = selectedOption.getAttribute('data-secretaria-nombre') || 'Sin Secretaría';

    document.getElementById('area').innerHTML = `<option value="${areaId}" selected>${areaNombre}</option>`;
    document.getElementById('secretaria').innerHTML = `<option value="${secretariaId}" selected>${secretariaNombre}</option>`;

    document.getElementById('areaId').value = areaId;
    document.getElementById('secretariaId').value = secretariaId;
}

function toggleForm() {
    formHoras.classList.toggle('hidden');
    btnCargarHoras.classList.toggle('hidden');
}

// Validación y envío del formulario
formHoras.addEventListener('submit', function (e) {
    e.preventDefault();

    const fechaInicio = new Date(document.getElementById('fechaInicio').value);
    const fechaFin = new Date(document.getElementById('fechaFin').value);

    // Validar fechas
    if (!fechaInicio || !fechaFin) {
        Swal.fire({
            title: 'Error',
            text: 'Debe completar las fechas de inicio y fin.',
            icon: 'error',
            confirmButtonText: 'OK'
        });
        return;
    }

    if (fechaInicio >= fechaFin) {
        Swal.fire({
            title: 'Error',
            text: 'La fecha y hora de inicio deben ser anteriores a la fecha y hora de fin.',
            icon: 'error',
            confirmButtonText: 'OK'
        });
        return;
    }

    if (!empleadoId) {
        Swal.fire({
            title: 'Error',
            text: 'Debe seleccionar un empleado.',
            icon: 'error',
            confirmButtonText: 'OK'
        });
        return;
    }

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
            if (data.success) {
                Swal.fire({
                    title: 'Éxito',
                    text: data.message,
                    icon: 'success',
                    confirmButtonText: 'OK'
                }).then(() => location.reload());
            } else {
                Swal.fire({
                    title: 'Error',
                    text: data.message,
                    icon: 'error',
                    confirmButtonText: 'OK'
                });
            }
        })
        .catch(error => {
            console.error('Error:', error);
            Swal.fire({
                title: 'Error',
                text: 'Ocurrió un error inesperado.',
                icon: 'error',
                confirmButtonText: 'OK'
            });
        });
});

document.addEventListener('DOMContentLoaded', () => {
    const { horas50, horas100, gasto50, gasto100, meses, horas50Historico, horas100Historico } = window.dashboardData;

    let horasYGastoChart, horasMesChart, gastoMesChart, horasHistoricasChart;

    // 1. Inicializar gráficos
    function initCharts() {
        const ctx = document.getElementById('horasYGastoChart').getContext('2d');
        horasYGastoChart = new Chart(ctx, {
            type: 'bar',
            data: {
                labels: ['50%', '100%'],
                datasets: [
                    {
                        label: 'Horas Realizadas',
                        data: [horas50, horas100],
                        backgroundColor: ['rgba(173, 216, 230, 0.8)', 'rgba(135, 206, 250, 0.8)'], // Celeste y azul claro
                        yAxisID: 'y-horas',
                    },
                    {
                        label: 'Gasto Mensual',
                        data: [gasto50, gasto100],
                        backgroundColor: ['rgba(135, 206, 250, 0.8)', 'rgba(173, 216, 230, 0.8)'], // Azul claro y celeste
                        yAxisID: 'y-gasto',
                    }
                ]
            },
            options: {
                responsive: true,
                scales: {
                    'y-horas': {
                        type: 'linear',
                        position: 'left',
                        title: {
                            display: true,
                            text: 'Horas',
                        },
                    },
                    'y-gasto': {
                        type: 'linear',
                        position: 'right',
                        title: {
                            display: true,
                            text: 'Gasto ($)',
                        },
                        grid: {
                            drawOnChartArea: false,
                        },
                    }
                },
                plugins: {
                    legend: {
                        position: 'top',
                    },
                    datalabels: {
                        anchor: 'end',
                        align: 'top',
                        formatter: (value, ctx) => {
                            if (ctx.dataset.label === 'Gasto Mensual') {
                                return `$${value.toLocaleString('es-AR')}`;
                            }
                            return value;
                        },
                        font: {
                            weight: 'bold',
                        }
                    }
                }
            },
            plugins: [ChartDataLabels]
        });

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

        // Actualizar gráfico de horas y gasto
        horasYGastoChart.data.datasets[0].data = [horas50, horas100]; // Actualizar las horas
        horasYGastoChart.data.datasets[1].data = [gasto50, gasto100]; // Actualizar el gasto
        horasYGastoChart.update();

        // Actualizar gráfico histórico
        horasHistoricasChart.data.datasets[0].data = historico50;
        horasHistoricasChart.data.datasets[1].data = historico100;
        horasHistoricasChart.update();
    }

    // 4. Manejador del filtro de áreas y secretarías
    function handleFilters() {
        const secretariaFilter = document.getElementById('secretariaFilter');
        const areaFilter = document.getElementById('areaFilter');

        // Actualizar áreas según la secretaría seleccionada
        secretariaFilter?.addEventListener('change', () => {
            const secretariaId = secretariaFilter.value;

            fetch(`/Dashboard/GetAreasBySecretaria?secretariaId=${secretariaId}`)
                .then(response => response.json())
                .then(areas => {
                    areaFilter.innerHTML = '<option value="">Todas las áreas</option>';
                    areas.forEach(area => {
                        areaFilter.innerHTML += `<option value="${area.areaId}">${area.nombreArea}</option>`;
                    });
                    // Actualizar los gráficos si corresponde
                    fetchChartData();
                })
                .catch(error => console.error('Error al cargar las áreas:', error));
        });

        // Filtrar datos según el área seleccionada
        areaFilter?.addEventListener('change', fetchChartData);
    }

    function fetchChartData() {
        const areaId = document.getElementById('areaFilter')?.value || '';
        const secretariaId = document.getElementById('secretariaFilter')?.value || '';

        fetch(`/Dashboard/GetChartData?areaId=${areaId}&secretariaId=${secretariaId}`)
            .then(response => response.json())
            .then(updateCharts)
            .catch(error => console.error('Error al cargar los datos del gráfico:', error));
    }

    //// 5. Lógica de carga de horas

    // 6. Ejecutar inicializaciones
    initCharts();
    handleFilters();
});
