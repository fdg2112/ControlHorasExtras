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

        public IActionResult Index()
        {
            var empleados = _context.Empleados
                         .Include(e => e.Area)
                         .Include(e => e.Secretaria)
                         .Include(e => e.Categoria)
                         .ToList();

            ViewData["Categorias"] = _context.CategoriasSalariales.ToList();
            ViewData["Empleados"] = empleados;
            ViewData["Secretarias"] = _context.Secretarias.ToList();
            ViewData["Areas"] = _context.Areas.ToList();

            // Verifica que 'empleados' no sea null antes de pasar a la vista
            if (empleados == null || empleados.Count == 0)
            {
                Console.WriteLine("No hay empleados disponibles.");
            }

            return View();
        }



        // Mostrar formulario de creación de empleados y lista de empleados
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
            if (ModelState.IsValid)
            {
                _context.Add(empleado);
                await _context.SaveChangesAsync();
                return Json(new { success = true, message = "Empleado registrado exitosamente." });
            }

            return Json(new { success = false, message = "Error al registrar el empleado." });
        }
    }
}
