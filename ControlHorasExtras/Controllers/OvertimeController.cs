using ControlHorasExtras.Data;
using ControlHorasExtras.Models;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace ControlHorasExtras.Controllers
{
    public class OvertimeController : Controller
    {
        private readonly OvertimeControlContext _context;

        public OvertimeController(OvertimeControlContext context)
        {
            _context = context;
        }

        // Método para cargar la vista del Dashboard
        // Método privado para obtener la lista de empleados
        private List<Empleado> GetEmpleados()
        {
            return _context.Empleados.ToList(); // Carga los empleados desde la base de datos
        }

        // Modificar el método Dashboard para incluir empleados
        public IActionResult Dashboard()
        {
            ViewData["Secretarias"] = GetSecretarias();
            ViewData["Areas"] = GetAreas();
            ViewData["Empleados"] = GetEmpleados();

            // Otros datos para la vista
            ViewData["HorasDelMes"] = 120; // Ejemplo
            ViewData["GastoDelMes"] = 45000.50; // Ejemplo

            return View();
        }


        // Método privado para obtener Secretarías
        private List<Secretaria> GetSecretarias()
        {
            return _context.Secretarias.ToList(); // Carga desde la base de datos
        }

        // Método privado para obtener Áreas
        private List<Area> GetAreas()
        {
            return _context.Areas.ToList(); // Carga desde la base de datos
        }

        // Mostrar el formulario de carga
        public IActionResult Create()
        {
            ViewData["Empleados"] = _context.Empleados.ToList();
            ViewData["Areas"] = _context.Areas.ToList();
            return View();
        }

        // Procesar la carga de horas extras
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Create(HorasExtra horasExtra)
        {
            if (ModelState.IsValid)
            {
                // Validar que las horas no se solapen
                var solapamiento = await _context.HorasExtras
                    .AnyAsync(h => h.EmpleadoId == horasExtra.EmpleadoId &&
                                   h.FechaHoraInicio.Date == horasExtra.FechaHoraInicio.Date &&
                                   !(h.FechaHoraFin <= horasExtra.FechaHoraInicio || h.FechaHoraInicio >= horasExtra.FechaHoraFin));

                if (solapamiento)
                {
                    ModelState.AddModelError("", "Las horas extras se solapan con otras ya registradas.");
                    return View(horasExtra);
                }

                // Guardar en la base de datos
                _context.Add(horasExtra);
                await _context.SaveChangesAsync();
                return RedirectToAction(nameof(Index), "Dashboard");
            }

            ViewData["Empleados"] = _context.Empleados.ToList();
            ViewData["Areas"] = _context.Areas.ToList();
            return View(horasExtra);
        }
    }
}
