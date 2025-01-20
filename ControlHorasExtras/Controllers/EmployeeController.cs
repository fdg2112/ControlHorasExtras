using ControlHorasExtras.Data;
using ControlHorasExtras.Models;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace ControlHorasExtras.Controllers
{
    public class EmployeeController : Controller
    {
        private readonly OvertimeControlContext _context;

        public EmployeeController(OvertimeControlContext context)
        {
            _context = context;
        }

        //public IActionResult Index(int page = 1, int pageSize = 10)
        //{
        //    var areaIdClaim = User.FindFirst("AreaId");
        //    var secretariaIdClaim = User.FindFirst("SecretariaId");

        //    // Determinar Área y Secretaría del usuario
        //    int? areaId = null;
        //    if (areaIdClaim != null && !string.IsNullOrEmpty(areaIdClaim.Value))
        //    {
        //        areaId = int.Parse(areaIdClaim.Value);
        //    }

        //    if (secretariaIdClaim == null || string.IsNullOrEmpty(secretariaIdClaim.Value))
        //    {
        //        return View("Error", new { message = "No se encontró el claim de Secretaría." });
        //    }
        //    int secretariaId = int.Parse(secretariaIdClaim.Value);

        //    // Filtrar empleados según el área y/o secretaría del usuario
        //    var query = _context.Empleados
        //        .Include(e => e.Area)
        //        .Include(e => e.Secretaria)
        //        .Include(e => e.Categoria)
        //        .Where(e =>
        //            (areaId.HasValue && e.AreaId == areaId) ||  // Empleados del área si el usuario pertenece a un área
        //            (!areaId.HasValue && e.SecretariaId == secretariaId)) // Empleados de la secretaría si el usuario no tiene área
        //        .AsQueryable();

        //    // Obtener el total de empleados para calcular la cantidad de páginas
        //    var totalEmpleados = query.Count();

        //    // Paginación: tomar los empleados según la página seleccionada
        //    var empleados = query
        //        .Skip((page - 1) * pageSize) // Omitir empleados de páginas anteriores
        //        .Take(pageSize) // Tomar solo los empleados de la página actual
        //        .ToList();

        //    // Calcular la cantidad total de páginas
        //    var totalPages = (int)Math.Ceiling((double)totalEmpleados / pageSize);

        //    // Pasar los datos a la vista
        //    ViewData["Empleados"] = empleados;
        //    ViewData["TotalPages"] = totalPages;
        //    ViewData["CurrentPage"] = page;
        //    ViewData["PageSize"] = pageSize;

        //    // Obtener áreas y secretarías para el formulario de creación
        //    var areas = _context.Areas.ToList();
        //    var secretarias = _context.Secretarias.ToList();
        //    var categorias = _context.CategoriasSalariales.ToList();

        //    ViewData["Areas"] = areas;
        //    ViewData["Secretarias"] = secretarias;
        //    ViewData["Categorias"] = categorias;

        //    return View();
        //}

        public IActionResult Index(int page = 1, int pageSize = 10)
        {
            var areaIdClaim = User.FindFirst("AreaId");
            var secretariaIdClaim = User.FindFirst("SecretariaId");
            var rolClaim = User.FindFirst("Rol");

            // Si el rol es "Intendente", mostramos todos los empleados sin filtrar por área ni secretaría
            if (rolClaim?.Value == "Intendente")
            {
                var empleados = _context.Empleados
                    .Include(e => e.Area)
                    .Include(e => e.Secretaria)
                    .Include(e => e.Categoria)
                    .ToList();

                // Paginación
                var totalEmpleados = empleados.Count();
                var empleadosPaginados = empleados
                    .Skip((page - 1) * pageSize)
                    .Take(pageSize)
                    .ToList();

                var totalPages = (int)Math.Ceiling((double)totalEmpleados / pageSize);

                ViewData["Empleados"] = empleadosPaginados;
                ViewData["TotalPages"] = totalPages;
                ViewData["CurrentPage"] = page;
                ViewData["PageSize"] = pageSize;
            }
            else
            {
                // Lógica anterior para usuarios con área o secretaría
                int? areaId = null;
                if (areaIdClaim != null && !string.IsNullOrEmpty(areaIdClaim.Value))
                {
                    areaId = int.Parse(areaIdClaim.Value);
                }

                if (secretariaIdClaim == null || string.IsNullOrEmpty(secretariaIdClaim.Value))
                {
                    return View("Error", new { message = "No se encontró el claim de Secretaría." });
                }
                int secretariaId = int.Parse(secretariaIdClaim.Value);

                var query = _context.Empleados
                    .Include(e => e.Area)
                    .Include(e => e.Secretaria)
                    .Include(e => e.Categoria)
                    .Where(e =>
                        (areaId.HasValue && e.AreaId == areaId) ||
                        (!areaId.HasValue && e.SecretariaId == secretariaId))
                    .AsQueryable();

                var totalEmpleados = query.Count();
                var empleados = query
                    .Skip((page - 1) * pageSize)
                    .Take(pageSize)
                    .ToList();

                var totalPages = (int)Math.Ceiling((double)totalEmpleados / pageSize);

                ViewData["Empleados"] = empleados;
                ViewData["TotalPages"] = totalPages;
                ViewData["CurrentPage"] = page;
                ViewData["PageSize"] = pageSize;
            }

            return View();
        }

        [HttpGet]
        public IActionResult CreateEmployee()
        {
            var areaIdClaim = User.FindFirst("AreaId");
            var secretariaIdClaim = User.FindFirst("SecretariaId");

            // Obtener áreas, secretarías y categorías salariales
            var areas = _context.Areas.ToList();
            var secretarias = _context.Secretarias.ToList();
            var categorias = _context.CategoriasSalariales.ToList();

            ViewData["Areas"] = areas;
            ViewData["Secretarias"] = secretarias;
            ViewData["Categorias"] = categorias;

            // Filtrar empleados que pertenecen al área y/o secretaría del usuario logueado
            int? areaId = areaIdClaim != null && !string.IsNullOrEmpty(areaIdClaim.Value) ? int.Parse(areaIdClaim.Value) : (int?)null;
            int? secretariaId = secretariaIdClaim != null && !string.IsNullOrEmpty(secretariaIdClaim.Value) ? int.Parse(secretariaIdClaim.Value) : (int?)null;

            var empleados = _context.Empleados
                .Include(e => e.Area)
                .Include(e => e.Secretaria)
                .Include(e => e.Categoria)
                .Where(e => (areaId.HasValue && e.AreaId == areaId) || (secretariaId.HasValue && e.SecretariaId == secretariaId))
                .ToList();

            ViewData["Empleados"] = empleados;

            return View();
        }

        // Crear nuevo empleado
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> CreateEmployee(Empleado empleado)
        {
            // Validar que el legajo sea único
            if (_context.Empleados.Any(e => e.Legajo == empleado.Legajo))
            {
                return Json(new
                {
                    success = false,
                    message = "El número de legajo ya está registrado."
                });
            }

            // Validar que el legajo sea un número de 3 dígitos
            if (empleado.Legajo < 0 && empleado.Legajo > 999)
            {
                return Json(new
                {
                    success = false,
                    message = "El número de legajo debe ser un número de 3 dígitos."
                });
            }

            ModelState.Remove("Area");
            ModelState.Remove("Secretaria");
            ModelState.Remove("Categoria");

            if (ModelState.IsValid)
            {
                _context.Empleados.Add(empleado);
                await _context.SaveChangesAsync();
                return Json(new
                {
                    success = true,
                    message = "Empleado registrado exitosamente."
                });
            }

            return Json(new
            {
                success = false,
                message = "Error al registrar el empleado."
            });
        }

        [HttpGet]
        public IActionResult GetAreasAndSecretarias()
        {
            var areaIdClaim = User.FindFirst("AreaId");
            var secretariaIdClaim = User.FindFirst("SecretariaId");

            // Determinar Área y Secretaría del usuario
            int? areaId = null;
            if (areaIdClaim != null && !string.IsNullOrEmpty(areaIdClaim.Value))
            {
                areaId = int.Parse(areaIdClaim.Value);
            }

            if (secretariaIdClaim == null || string.IsNullOrEmpty(secretariaIdClaim.Value))
            {
                return Json(new { error = "No se encontró el claim de Secretaría." });
            }
            int secretariaId = int.Parse(secretariaIdClaim.Value);

            // Obtener áreas y secretarías del usuario
            var areas = _context.Areas
                .Where(a => a.SecretariaId == secretariaId && (!areaId.HasValue || a.AreaId == areaId))
                .Select(a => new { id = a.AreaId, nombre = a.NombreArea })
                .ToList();

            var secretarias = _context.Secretarias
                .Where(s => s.SecretariaId == secretariaId)
                .Select(s => new { id = s.SecretariaId, nombre = s.NombreSecretaria })
                .ToList();

            // Devolver datos con las áreas y secretarías por defecto
            return Json(new
            {
                areas,
                secretarias,
                defaultAreaId = areaId, // Área predeterminada
                defaultSecretariaId = secretariaId // Secretaría predeterminada
            });
        }

        [HttpGet]
        public IActionResult CheckLegajo(int legajo)
        {
            // Verificar si el legajo ya existe en la base de datos
            var empleadoExistente = _context.Empleados
                .Include(e => e.Area)
                .Include(e => e.Secretaria)
                .Where(e => e.Legajo == legajo)
                .Select(e => new
                {
                    Nombre = e.Nombre,
                    Apellido = e.Apellido,
                    AreaNombre = e.Area != null ? e.Area.NombreArea : "Sin Área",
                    SecretariaNombre = e.Secretaria != null ? e.Secretaria.NombreSecretaria : "Sin Secretaría"
                })
                .FirstOrDefault();

            if (empleadoExistente != null)
            {
                return Json(new
                {
                    exists = true,
                    empleado = empleadoExistente
                });
            }

            return Json(new { exists = false });
        }

    }
}
