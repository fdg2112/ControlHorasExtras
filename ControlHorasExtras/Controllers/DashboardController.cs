using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using System.Linq;
using System.Threading.Tasks;
using ControlHorasExtras.Data;
using Microsoft.AspNetCore.Authorization;

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
            // Cargar datos para el Dashboard
            var horasDelMes = await _context.HorasExtras
                .Where(h => h.FechaHoraInicio.Month == DateTime.Now.Month && h.FechaHoraInicio.Year == DateTime.Now.Year)
                .SumAsync(h => EF.Functions.DateDiffHour(h.FechaHoraInicio, h.FechaHoraFin));

            var gastoDelMes = await _context.HorasExtras
                .Where(h => h.FechaHoraInicio.Month == DateTime.Now.Month && h.FechaHoraInicio.Year == DateTime.Now.Year)
                .SumAsync(h => EF.Functions.DateDiffHour(h.FechaHoraInicio, h.FechaHoraFin) * (h.TipoHora == "50" ? 1.5 : 2.0));

            var horasPorMes = await _context.HorasExtras
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
