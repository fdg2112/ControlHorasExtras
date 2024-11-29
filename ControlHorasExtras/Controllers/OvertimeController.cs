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
