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
            return View();
        }

        // Mostrar el formulario de carga
        [HttpGet]
        public IActionResult Create()
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
                return Json(new { error = "No se encontró el claim de SecretariaId." });
            }
            int secretariaId = int.Parse(secretariaIdClaim.Value);

            // Filtrar empleados según el rol del usuario
            var empleados = _context.Empleados
                .Where(e =>
                    (areaId.HasValue && e.AreaId == areaId) || // Empleados del área si existe AreaId
                    (!areaId.HasValue && e.SecretariaId == secretariaId)) // Empleados de la secretaría si no hay Área
                .Select(e => new { id = e.EmpleadoId, legajo = e.Legajo, nombre = e.Nombre, apellido = e.Apellido })
                .ToList();

            // Filtrar secretarías
            var secretarias = _context.Secretarias
                .Select(s => new { id = s.SecretariaId, nombre = s.NombreSecretaria })
                .ToList();

            // Filtrar áreas
            var areas = _context.Areas
                .Where(a => a.SecretariaId == secretariaId)
                .Select(a => new { id = a.AreaId, nombre = a.NombreArea })
                .ToList();

            // Devolver datos en formato JSON
            return Json(new
            {
                empleados,
                secretarias,
                areas
            });
        }


        //Procesar la carga de horas extras
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

        //[HttpPost]
        //[ValidateAntiForgeryToken]
        //public async Task<IActionResult> Create(HorasExtra horasExtra)
        //{
        //    if (ModelState.IsValid)
        //    {
        //        // Obtener área y secretaría del empleado
        //        var empleado = await _context.Empleados
        //            .Where(e => e.EmpleadoId == horasExtra.EmpleadoId)
        //            .Select(e => new { e.AreaId, e.SecretariaId })
        //            .FirstOrDefaultAsync();

        //        if (empleado == null)
        //        {
        //            return Json(new { success = false, message = "El empleado seleccionado no existe." });
        //        }

        //        // Asignar Área y Secretaría al modelo
        //        horasExtra.AreaId = empleado.AreaId ?? 0; // Manejar nulos si AreaId puede ser nulo
        //        horasExtra.SecretariaId = empleado.SecretariaId;

        //        // Validar que las horas no se solapen
        //        var solapamiento = await _context.HorasExtras
        //            .AnyAsync(h => h.EmpleadoId == horasExtra.EmpleadoId &&
        //                           h.FechaHoraInicio.Date == horasExtra.FechaHoraInicio.Date &&
        //                           !(h.FechaHoraFin <= horasExtra.FechaHoraInicio || h.FechaHoraInicio >= horasExtra.FechaHoraFin));

        //        if (solapamiento)
        //        {
        //            return Json(new { success = false, message = "Las horas extras se solapan con otras ya registradas." });
        //        }

        //        // Guardar en la base de datos
        //        _context.Add(horasExtra);
        //        await _context.SaveChangesAsync();

        //        return Json(new { success = true, message = "Horas extras guardadas exitosamente." });
        //    }

        //    return Json(new { success = false, message = "Error al guardar las horas extras. Por favor, revise los datos ingresados." });
        //}
    }
}


