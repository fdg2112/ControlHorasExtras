using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using System.Linq;
using System.Threading.Tasks;
using ControlHorasExtras.Data;

namespace ControlHorasExtras.Controllers;

public class DashboardController : Controller
{
    private readonly OvertimeControlContext _context;

    public DashboardController(OvertimeControlContext context)
    {
        _context = context;
    }

    public async Task<IActionResult> Index()
    {
        // Total de horas extras del mes actual
        var horasDelMes = await _context.HorasExtras
            .Where(h => h.FechaHoraInicio.Month == DateTime.Now.Month && h.FechaHoraInicio.Year == DateTime.Now.Year)
            .SumAsync(h => EF.Functions.DateDiffHour(h.FechaHoraInicio, h.FechaHoraFin));

        // Gasto en horas extras del mes actual
        var gastoDelMes = await _context.HorasExtras
            .Where(h => h.FechaHoraInicio.Month == DateTime.Now.Month && h.FechaHoraInicio.Year == DateTime.Now.Year)
            .SumAsync(h => EF.Functions.DateDiffHour(h.FechaHoraInicio, h.FechaHoraFin) * (h.TipoHora == "50" ? 1.5 : 2.0));

        // Datos para gráficos
        var horasPorMes = await _context.HorasExtras
            .GroupBy(h => new { h.FechaHoraInicio.Year, h.FechaHoraInicio.Month })
            .Select(g => new
            {
                Mes = new DateTime(g.Key.Year, g.Key.Month, 1).ToString("MMMM yyyy"), // Ejemplo: "Noviembre 2024"
                TotalHoras = g.Sum(h => EF.Functions.DateDiffHour(h.FechaHoraInicio, h.FechaHoraFin))
            })
            .ToListAsync();

        // Preparar datos para la vista
        ViewData["HorasDelMes"] = horasDelMes;
        ViewData["GastoDelMes"] = gastoDelMes;
        ViewData["HorasPorMes"] = horasPorMes;

        return View();
    }
}
