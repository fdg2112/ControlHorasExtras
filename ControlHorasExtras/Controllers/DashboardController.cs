using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using System.Linq;
using System.Threading.Tasks;
using ControlHorasExtras.Data;
using Microsoft.AspNetCore.Authorization;
using ControlHorasExtras.Models;

namespace ControlHorasExtras.Controllers
{
    [Authorize]  // Esto garantiza que solo los usuarios autenticados pueden acceder al Dashboard
    public class DashboardController : Controller
    {
        private readonly OvertimeControlContext _context;

        public DashboardController(OvertimeControlContext context)
        {
            _context = context;
        }

        public async Task<IActionResult> Index()
        {
            // Obtener los claims del usuario logueado
            var usuarioId = int.Parse(User.FindFirst("UsuarioId").Value);
            var rol = User.FindFirst("Rol").Value;

            // Filtrar los datos según el rol
            IQueryable<HorasExtra> query = _context.HorasExtras;

            if (rol == "Jefe de Área")
            {
                var areaId = await _context.Usuarios
                    .Where(u => u.UsuarioId == usuarioId)
                    .Select(u => u.AreaId)
                    .FirstOrDefaultAsync();

                query = query.Where(h => h.AreaId == areaId);
            }
            else if (rol == "Secretario")
            {
                var secretariaId = await _context.Usuarios
                    .Where(u => u.UsuarioId == usuarioId)
                    .Select(u => u.SecretariaId)
                    .FirstOrDefaultAsync();

                query = query.Where(h => h.SecretariaId == secretariaId);
            }
            // Intendente y Hacienda no filtran datos
            else if (rol == "Secretario Hacienda" || rol == "Intendente")
            {
                // Ver todo
            }

            // Calcular datos del dashboard
            var horasDelMes = await query
                .Where(h => h.FechaHoraInicio.Month == DateTime.Now.Month && h.FechaHoraInicio.Year == DateTime.Now.Year)
                .SumAsync(h => EF.Functions.DateDiffHour(h.FechaHoraInicio, h.FechaHoraFin));

            var gastoDelMes = await query
                .Where(h => h.FechaHoraInicio.Month == DateTime.Now.Month && h.FechaHoraInicio.Year == DateTime.Now.Year)
                .SumAsync(h => EF.Functions.DateDiffHour(h.FechaHoraInicio, h.FechaHoraFin) * (h.TipoHora == "50" ? 1.5 : 2.0));

            var horasPorMes = await query
                .GroupBy(h => new { h.FechaHoraInicio.Year, h.FechaHoraInicio.Month })
                .Select(g => new
                {
                    Mes = new DateTime(g.Key.Year, g.Key.Month, 1).ToString("MMMM yyyy"),
                    TotalHoras = g.Sum(h => EF.Functions.DateDiffHour(h.FechaHoraInicio, h.FechaHoraFin))
                })
                .ToListAsync();

            // Pasar datos a la vista
            ViewData["HorasDelMes"] = horasDelMes;
            ViewData["GastoDelMes"] = gastoDelMes;
            ViewData["HorasPorMes"] = horasPorMes;

            return View();
        }

    }
}
