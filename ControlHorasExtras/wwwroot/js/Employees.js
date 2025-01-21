
document.addEventListener('DOMContentLoaded', () => {
    let empleadosData = [];
    let currentPage = 1;
    const rowsPerPage = 10;

    // Llamada inicial para cargar empleados
    fetchEmpleados();

    // Evento para búsqueda
    document.getElementById('searchInput').addEventListener('keyup', function () {
        const searchValue = this.value.toLowerCase();
        const filteredData = empleadosData.filter(emp =>
            `${emp.legajo} ${emp.apellido} ${emp.nombre} ${emp.categoriaNombre} ${emp.areaNombre} ${emp.secretariaNombre}`.toLowerCase().includes(searchValue)
        );
        renderTable(filteredData);
    });

    // Función para obtener empleados según el área seleccionada
    function fetchEmpleados() {
        const areaId = document.getElementById('areaFilter')?.value || '';

        fetch(`/Employee/GetEmpleados?areaId=${areaId}`)
            .then(response => response.json())
            .then(data => {
                console.log(data);
                empleadosData = data;
                renderTable(empleadosData);
            })
            .catch(error => console.error('Error al cargar empleados:', error));
    }

    // Renderizar la tabla con los datos
    function renderTable(data) {
        const tbody = document.querySelector('#empleadosTable tbody');
        const start = (currentPage - 1) * rowsPerPage;
        const end = start + rowsPerPage;

        tbody.innerHTML = ''; // Limpiar contenido previo

        // Renderizar solo los empleados de la página actual
        const currentData = data.slice(start, end);
        currentData.forEach(emp => {
            tbody.innerHTML += `
            <tr>
                <td>${emp.legajo}</td>
                <td>${emp.apellido}</td>
                <td>${emp.nombre}</td>
                <td>${emp.categoriaNombre}</td>
                <td>${emp.areaNombre}</td>
                <td>${emp.secretariaNombre}</td>
                <td>
                    <a href="@Url.Action("EditEmpleado", new { id = empleado.EmpleadoId })" class="btn btn-warning btn-sm">Editar</a>
                </td>
            </tr>
        `;
        });

        // Actualizar información de paginación
        document.getElementById("pageInfo").innerText = `Página ${currentPage} de ${Math.ceil(data.length / rowsPerPage)}`;
    }

    // Actualizar controles de paginación
    function updatePagination(totalRows) {
        const totalPages = Math.ceil(totalRows / rowsPerPage);
        document.getElementById('pageInfo').textContent = `Página ${currentPage} de ${totalPages}`;
    }

    // Funciones de paginación
    window.prevPage = function () {
        if (currentPage > 1) {
            currentPage--;
            renderTable(empleadosData);
        }
    };

    window.nextPage = function () {
        const totalPages = Math.ceil(empleadosData.length / rowsPerPage);
        if (currentPage < totalPages) {
            currentPage++;
            renderTable(empleadosData);
        }
    };

    // Función para ordenar la tabla
    window.sortTable = function (columnIndex) {
        // Determinar dirección de orden
        const ths = document.querySelectorAll('#empleadosTable th');
        const direction = ths[columnIndex].dataset.direction === 'asc' ? 'desc' : 'asc';

        // Resetear direcciones de todos los encabezados
        ths.forEach(th => th.removeAttribute('data-direction'));
        ths[columnIndex].setAttribute('data-direction', direction);

        // Ordenar el dataset global completo (empleadosData)
        empleadosData.sort((a, b) => {
            const aValue = Object.values(a)[columnIndex];
            const bValue = Object.values(b)[columnIndex];

            if (typeof aValue === 'string' && typeof bValue === 'string') {
                // Ordenar cadenas (ignorando mayúsculas)
                return direction === 'asc'
                    ? aValue.localeCompare(bValue)
                    : bValue.localeCompare(aValue);
            }

            // Ordenar números o valores no cadenas
            return direction === 'asc' ? aValue - bValue : bValue - aValue;
        });

        // Renderizar nuevamente la tabla paginada después de ordenar
        renderTable(empleadosData);
    };
});



// Formulario de Carga de Empleados

const formEmpleado = document.getElementById('formEmpleado');
const btnAgregarEmpleado = document.getElementById('btnAgregarEmpleado');
function cargarFormulario() {
    formEmpleado.classList.toggle("hidden");
    btnAgregarEmpleado.classList.toggle("hidden");

    if (!formEmpleado.classList.contains("hidden")) {
        // Solicitar datos filtrados según el usuario logueado
        fetch("/Employee/GetAreasAndSecretarias")
            .then((response) => response.json())
            .then((data) => {
                cargarOpcionesConSeleccion(data);
            })
            .catch((error) => console.error("Error al cargar las opciones:", error));
    }
}
function cargarOpcionesConSeleccion(data) {
    // Cargar áreas
    const areaSelect = document.getElementById("areaId");
    areaSelect.innerHTML = '<option value="" disabled>Seleccione un área</option>';
    data.areas.forEach((area) => {
        const selected = data.defaultAreaId === area.id ? "selected" : "";
        areaSelect.innerHTML += `<option value="${area.id}" ${selected}>${area.nombre}</option>`;
    });

    // Cargar secretarías
    const secretariaSelect = document.getElementById("secretariaId");
    secretariaSelect.innerHTML = '<option value="" disabled>Seleccione una secretaría</option>';
    data.secretarias.forEach((secretaria) => {
        const selected = data.defaultSecretariaId === secretaria.id ? "selected" : "";
        secretariaSelect.innerHTML += `<option value="${secretaria.id}" ${selected}>${secretaria.nombre}</option>`;
    });
}
function toggleForm() {
    formEmpleado.classList.toggle('hidden');
    btnAgregarEmpleado.classList.toggle('hidden');
}
formEmpleado.addEventListener('submit', function (e) {
    e.preventDefault();
    const formData = new FormData(formEmpleado);
    fetch('/Employee/CreateEmployee', { // Cambiado el endpoint
        method: 'POST',
        body: formData,
        headers: {
            'X-Requested-With': 'XMLHttpRequest',
            'RequestVerificationToken': document.querySelector('input[name="__RequestVerificationToken"]').value
        }
    })
    .then(response => {
        if (!response.ok) {
            throw new Error(`HTTP error! Status: ${response.status}`);
        }
        return response.json();
    })
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
        console.error('Error en la solicitud:', error);
        Swal.fire({
            title: 'Error',
            text: 'Ocurrió un error inesperado.',
            icon: 'error',
            confirmButtonText: 'OK'
        });
    });
});
document.getElementById("legajo").addEventListener("blur", function () {
    const legajoInput = this.value;

    // Validar que sea un número de 3 dígitos
    if (!/^\d{3}$/.test(legajoInput)) {
        Swal.fire({
            title: "Error",
            text: "El legajo debe ser un número de 3 dígitos.",
            icon: "error",
            confirmButtonText: "OK"
        });
        this.value = ""; // Limpiar el campo
        return;
    }

    // Verificar si el legajo ya existe en la base de datos
    fetch(`/Employee/CheckLegajo?legajo=${legajoInput}`)
        .then(response => {
            if (!response.ok) {
                throw new Error(`HTTP error! Status: ${response.status}`);
            }
            return response.json();
        })
        .then(data => {
            if (data.exists) {
                Swal.fire({
                    title: "Legajo ya registrado",
                    html: `
                        <p>El legajo ingresado pertenece a:</p>
                        <p><strong>${data.empleado.nombre} ${data.empleado.apellido}</strong></p>
                        <p>Área: ${data.empleado.areaNombre}</p>
                        <p>Secretaría: ${data.empleado.secretariaNombre}</p>
                        <p>Para agregar a este empleado tu área, debes solicitar la transferencia a su superior.</p>
                    `,
                    icon: "warning",
                    confirmButtonText: "OK"
                });
                document.getElementById("legajo").value = ""; // Limpiar el campo
            }
        })
        .catch(error => console.error("Error al verificar el legajo:", error));
});
