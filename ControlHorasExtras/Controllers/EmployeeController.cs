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

        public async Task<IActionResult> GetEmpleados(int? areaId = null)
        {
            // Obtener datos del usuario logueado
            var rol = User.FindFirst("Rol")?.Value;
            var areaIdClaim = User.FindFirst("AreaId")?.Value;
            var secretariaIdClaim = User.FindFirst("SecretariaId")?.Value;

            int? areaIdUsuario = string.IsNullOrEmpty(areaIdClaim) ? null : int.Parse(areaIdClaim);
            int? secretariaIdUsuario = string.IsNullOrEmpty(secretariaIdClaim) ? null : int.Parse(secretariaIdClaim);

            var empleadosQuery = _context.Empleados.AsQueryable();

            // Filtrar según el rol del usuario
            if (rol == "Jefe de Área" && areaIdUsuario.HasValue)
            {
                empleadosQuery = empleadosQuery.Where(e => e.AreaId == areaIdUsuario.Value);
            }
            else if (rol == "Secretario" && secretariaIdUsuario.HasValue)
            {
                empleadosQuery = empleadosQuery.Where(e => e.Area.SecretariaId == secretariaIdUsuario.Value);
                if (areaId.HasValue)
                {
                    empleadosQuery = empleadosQuery.Where(e => e.AreaId == areaId.Value);
                }
            }
            else if (rol == "Intendente" || rol == "Secretario Hacienda")
            {
                // Intendentes y Secretarios de Hacienda no tienen filtro inicial
            }
            else if (areaId.HasValue)
            {
                empleadosQuery = empleadosQuery.Where(e => e.AreaId == areaId.Value);
            }

            var empleados = await empleadosQuery
                .Select(e => new
                {
                    e.Legajo,
                    e.Apellido,
                    e.Nombre,
                    categoriaNombre = e.Categoria.NombreCategoria,
                    areaNombre = e.Area.NombreArea,
                    secretariaNombre = e.Secretaria.NombreSecretaria,
                })
                .ToListAsync();

            return Json(empleados);
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

        [HttpGet]
        public IActionResult GetEmpleadoById(int id)
        {
            var empleado = _context.Empleados
                .Include(e => e.Categoria)
                .Include(e => e.Area)
                .Include(e => e.Secretaria)
                .FirstOrDefault(e => e.EmpleadoId == id);

            if (empleado == null)
            {
                return NotFound();
            }

            // Obtener datos adicionales como listas de categorías, áreas y secretarías
            var categorias = _context.CategoriasSalariales.Select(c => new { c.CategoriaId, c.NombreCategoria }).ToList();
            var areas = _context.Areas.Select(a => new { a.AreaId, a.NombreArea }).ToList();
            var secretarias = _context.Secretarias.Select(s => new { s.SecretariaId, s.NombreSecretaria }).ToList();

            return Json(new
            {
                nombre = empleado.Nombre,
                apellido = empleado.Apellido,
                categoriaId = empleado.CategoriaId,
                areaId = empleado.AreaId,
                secretariaId = empleado.SecretariaId,
                categorias,
                areas,
                secretarias
            });
        }

        [HttpPost]
        public IActionResult EditEmpleado(int id, Empleado model)
        {
            var empleado = _context.Empleados.FirstOrDefault(e => e.EmpleadoId == id);
            if (empleado == null)
            {
                return NotFound();
            }

            // Actualizar datos del empleado
            empleado.Nombre = model.Nombre;
            empleado.Apellido = model.Apellido;
            empleado.CategoriaId = model.CategoriaId;
            empleado.AreaId = model.AreaId;
            empleado.SecretariaId = model.SecretariaId;

            _context.SaveChanges();

            return Json(new { success = true, message = "Empleado actualizado correctamente" });
        }

    }
}
