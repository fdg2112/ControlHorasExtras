let empleadosData = [];
var currentPage = 1;
var rowsPerPage = 10;
function showPage(page) {
    var table = document.getElementById("empleadosTable");
    var rows = table.rows;
    var start = (page - 1) * rowsPerPage + 1;
    var end = start + rowsPerPage - 1;

    for (var i = 1; i < rows.length; i++) {
        if (i >= start && i <= end) {
            rows[i].style.display = "";
        } else {
            rows[i].style.display = "none";
        }
    }
}
function prevPage() {
    if (currentPage > 1) {
        currentPage--;
        showPage(currentPage);
    }
}
function nextPage() {
    var table = document.getElementById("empleadosTable");
    var rows = table.rows;
    if (currentPage < Math.ceil((rows.length - 1) / rowsPerPage)) {
        currentPage++;
        showPage(currentPage);
    }
}
function sortTable(columnIndex) {
    var table = document.getElementById("empleadosTable");
    var rows = table.rows;
    var switching = true;
    var shouldSwitch;
    var direction = "asc";
    var switchCount = 0;
    while (switching) {
        switching = false;
        var rowsArray = Array.from(rows).slice(1);
        for (var i = 0; i < rowsArray.length - 1; i++) {
            shouldSwitch = false;
            var x = rowsArray[i].getElementsByTagName("TD")[columnIndex];
            var y = rowsArray[i + 1].getElementsByTagName("TD")[columnIndex];
            if (direction == "asc") {
                if (x.innerHTML.toLowerCase() > y.innerHTML.toLowerCase()) {
                    shouldSwitch = true;
                    break;
                }
            } else if (direction == "desc") {
                if (x.innerHTML.toLowerCase() < y.innerHTML.toLowerCase()) {
                    shouldSwitch = true;
                    break;
                }
            }
        }
        if (shouldSwitch) {
            rowsArray[i].parentNode.insertBefore(rowsArray[i + 1], rowsArray[i]);
            switching = true;
            switchCount++;
        } else {
            if (switchCount == 0 && direction == "asc") {
                direction = "desc";
                switching = true;
            }
        }
    }
    showPage(currentPage); // Actualizar la paginación después de ordenar
}

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
