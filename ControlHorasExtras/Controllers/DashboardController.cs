using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using ControlHorasExtras.Data;
using Microsoft.AspNetCore.Authorization;
using ControlHorasExtras.Models;
using System.Globalization;

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
            var usuarioIdClaim = User.FindFirst("UsuarioId");
            var rolClaim = User.FindFirst("Rol");
            var areaIdClaim = User.FindFirst("AreaId");
            var secretariaIdClaim = User.FindFirst("SecretariaId");

            if (usuarioIdClaim == null || rolClaim == null)
            {
                return Unauthorized(); // Redirigir a una página de error o al login
            }

            // Parsear los valores de los claims
            var usuarioId = int.Parse(usuarioIdClaim.Value);
            var rol = rolClaim.Value;
            int? areaId = string.IsNullOrEmpty(areaIdClaim?.Value) ? null : int.Parse(areaIdClaim.Value);
            int secretariaId = int.Parse(secretariaIdClaim.Value);

            // Incluir relaciones necesarias
            IQueryable<HorasExtra> query = _context.HorasExtras
                .Include(h => h.Area)
                .Include(h => h.Empleado)
                .Include(h => h.Secretaria)
                .AsQueryable();

            // Filtrar por rol
            if (rol == "Jefe de Área" && areaId.HasValue)
            {
                query = query.Where(h => h.AreaId == areaId.Value);
            }
            else if (rol == "Secretario")
            {
                query = query.Where(h => h.SecretariaId == secretariaId);
            }
            else if (rol == "Intendente" || rol == "Secretario Hacienda")
            {
                var secretarias = await _context.Secretarias.ToListAsync();
                ViewData["Secretarias"] = secretarias;
            }

            // Obtener los últimos 12 meses
            var mesActual = DateTime.Now.Month;
            var anioActual = DateTime.Now.Year;
            var fechaInicio = DateTime.Now.AddMonths(-11);

            // Datos del mes actual
            var horasDelMes = await query
                .Where(h => h.FechaHoraInicio.Month == mesActual && h.FechaHoraInicio.Year == anioActual)
                .GroupBy(h => h.TipoHora)
                .Select(g => new
                {
                    TipoHora = g.Key,
                    TotalHoras = g.Sum(h => h.CantidadHoras)
                })
                .ToListAsync();

            var horas50 = horasDelMes.FirstOrDefault(h => h.TipoHora == "50%")?.TotalHoras ?? 0;
            var horas100 = horasDelMes.FirstOrDefault(h => h.TipoHora == "100%")?.TotalHoras ?? 0;

            // Gasto del mes actual
            var gastoDelMes = await query
                .Where(h => h.FechaHoraInicio.Month == mesActual && h.FechaHoraInicio.Year == anioActual)
                .Select(h => new
                {
                    TipoHora = h.TipoHora,
                    CantidadHoras = h.CantidadHoras,
                    ValorHora = h.TipoHora.Trim() == "50%"
                        ? (h.Empleado.Categoria.SueldoBasico / 132) * 1.5m
                        : (h.Empleado.Categoria.SueldoBasico / 132) * 2m
                })
                .GroupBy(h => h.TipoHora)
                .Select(g => new
                {
                    TipoHora = g.Key,
                    TotalGasto = g.Sum(h => h.CantidadHoras * h.ValorHora)
                })
                .ToListAsync();

            var gasto50 = gastoDelMes.FirstOrDefault(g => g.TipoHora.Trim() == "50%")?.TotalGasto ?? 0;
            var gasto100 = gastoDelMes.FirstOrDefault(g => g.TipoHora.Trim() == "100%")?.TotalGasto ?? 0;

            // Histórico
            var historicoHoras = await query
                .Where(h => h.FechaHoraInicio >= fechaInicio)
                .GroupBy(h => new { h.FechaHoraInicio.Year, h.FechaHoraInicio.Month, h.TipoHora })
                .Select(g => new
                {
                    Mes = g.Key.Month,
                    Anio = g.Key.Year,
                    TipoHora = g.Key.TipoHora,
                    TotalHoras = g.Sum(h => h.CantidadHoras)
                })
                .OrderBy(h => h.Anio)
                .ThenBy(h => h.Mes)
                .ToListAsync();

            var meses = historicoHoras
                .Select(h => $"{h.Mes:00}/{h.Anio}")
                .Distinct()
                .ToList();

            var horas50Historico = meses
                .Select(m => historicoHoras
                    .Where(h => $"{h.Mes:00}/{h.Anio}" == m && h.TipoHora.Trim() == "50%")
                    .Sum(h => h.TotalHoras))
                .ToList();

            var horas100Historico = meses
                .Select(m => historicoHoras
                    .Where(h => $"{h.Mes:00}/{h.Anio}" == m && h.TipoHora.Trim() == "100%")
                    .Sum(h => h.TotalHoras))
                .ToList();

            // Obtener las áreas y secretarías según el rol
            var areas = await _context.Areas
                .Where(a => rol == "Secretario" ? a.SecretariaId == secretariaId : true)
                .ToListAsync();

            ViewData["Areas"] = areas;



            ViewData["Horas50"] = horas50;
            ViewData["Horas100"] = horas100;
            ViewData["Gasto50"] = Math.Round(gasto50, 2);
            ViewData["Gasto100"] = Math.Round(gasto100, 2);
            ViewData["Meses"] = meses;
            ViewData["Horas50Historico"] = horas50Historico;
            ViewData["Horas100Historico"] = horas100Historico;
            ViewData["GastoTotalFormatted"] = (gasto50 + gasto100).ToString("C", new CultureInfo("es-AR"));

            return View();
        }

        [HttpGet]
        public async Task<IActionResult> GetChartData(int? areaId = null, int? secretariaId = null)
        {
            var currentMonth = DateTime.Now.Month;
            var currentYear = DateTime.Now.Year;
            var startDate = new DateTime(currentYear, currentMonth, 1).AddMonths(-11);

            var query = _context.HorasExtras
                .Include(h => h.Empleado)
                .ThenInclude(e => e.Categoria)
                .Include(h => h.Area)
                .Include(h => h.Secretaria)
                .AsQueryable();

            // Filtrar por área si se seleccionó una
            if (areaId.HasValue)
            {
                query = query.Where(h => h.AreaId == areaId.Value);
            }
            // Filtrar por secretaría si se seleccionó una y no hay área
            else if (secretariaId.HasValue)
            {
                query = query.Where(h => h.SecretariaId == secretariaId.Value);
            }

            // Si no hay filtros, devolver datos de todas las secretarías y áreas
            // Esto ocurre cuando el rol es Intendente o Secretario Hacienda
            // Y no se selecciona un filtro explícito

            // Filtrar solo las horas del mes actual
            query = query.Where(h => h.FechaHoraInicio.Month == currentMonth && h.FechaHoraInicio.Year == currentYear);

            // Horas y gastos
            var horas = await query.GroupBy(h => h.TipoHora).Select(g => new
            {
                TipoHora = g.Key,
                TotalHoras = g.Sum(h => h.CantidadHoras)
            }).ToListAsync();

            var gastos = await query.Select(h => new
            {
                h.TipoHora,
                h.CantidadHoras,
                ValorHora = h.TipoHora == "50%"
                    ? (h.Empleado.Categoria.SueldoBasico / 132) * 1.5m
                    : (h.Empleado.Categoria.SueldoBasico / 132) * 2m
            }).GroupBy(h => h.TipoHora).Select(g => new
            {
                TipoHora = g.Key,
                TotalGasto = g.Sum(h => h.CantidadHoras * h.ValorHora)
            }).ToListAsync();

            // Histórico
            var historicoQuery = _context.HorasExtras
                .Include(h => h.Empleado)
                .Include(h => h.Area)
                .AsQueryable();

            if (areaId.HasValue)
            {
                historicoQuery = historicoQuery.Where(h => h.AreaId == areaId.Value);
            }
            else if (secretariaId.HasValue)
            {
                historicoQuery = historicoQuery.Where(h => h.SecretariaId == secretariaId.Value);
            }

            var historico = await historicoQuery
                .Where(h => h.FechaHoraInicio >= startDate)
                .GroupBy(h => new { h.FechaHoraInicio.Year, h.FechaHoraInicio.Month, h.TipoHora })
                .Select(g => new
                {
                    Mes = g.Key.Month,
                    Anio = g.Key.Year,
                    TipoHora = g.Key.TipoHora,
                    TotalHoras = g.Sum(h => h.CantidadHoras)
                }).OrderBy(h => h.Anio).ThenBy(h => h.Mes)
                .ToListAsync();

            var historico50 = historico
                .Where(h => h.TipoHora == "50%")
                .Select(h => h.TotalHoras)
                .ToList();

            var historico100 = historico
                .Where(h => h.TipoHora == "100%")
                .Select(h => h.TotalHoras)
                .ToList();

            return Json(new
            {
                Horas50 = horas.FirstOrDefault(h => h.TipoHora == "50%")?.TotalHoras ?? 0,
                Horas100 = horas.FirstOrDefault(h => h.TipoHora == "100%")?.TotalHoras ?? 0,
                Gasto50 = gastos.FirstOrDefault(g => g.TipoHora == "50%")?.TotalGasto ?? 0,
                Gasto100 = gastos.FirstOrDefault(g => g.TipoHora == "100%")?.TotalGasto ?? 0,
                Historico50 = historico50,
                Historico100 = historico100
            });
        }

        [HttpGet]
        public async Task<IActionResult> GetAreasBySecretaria(int? secretariaId)
        {
            var areas = await _context.Areas
                .Where(a => !secretariaId.HasValue || a.SecretariaId == secretariaId.Value)
                .Select(a => new { a.AreaId, a.NombreArea })
                .ToListAsync();

            return Json(areas);
        }

        [HttpGet]
        public async Task<IActionResult> GetEmpleadosPorArea(int? areaId = null)
        {
            // Obtener datos del usuario logueado
            var rol = User.FindFirst("Rol")?.Value;
            var areaIdClaim = User.FindFirst("AreaId")?.Value;
            var secretariaIdClaim = User.FindFirst("SecretariaId")?.Value;

            int? areaIdUsuario = string.IsNullOrEmpty(areaIdClaim) ? null : int.Parse(areaIdClaim);
            int? secretariaIdUsuario = string.IsNullOrEmpty(secretariaIdClaim) ? null : int.Parse(secretariaIdClaim);

            var mesActual = DateTime.Now.Month;
            var anioActual = DateTime.Now.Year;
            var mesAnterior = mesActual == 1 ? 12 : mesActual - 1;
            var anioMesAnterior = mesActual == 1 ? anioActual - 1 : anioActual;

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
                    Horas50Actual = e.HorasExtras
                        .Where(h => h.FechaHoraInicio.Month == mesActual &&
                                    h.FechaHoraInicio.Year == anioActual &&
                                    h.TipoHora == "50%")
                        .Sum(h => h.CantidadHoras),
                    Horas100Actual = e.HorasExtras
                        .Where(h => h.FechaHoraInicio.Month == mesActual &&
                                    h.FechaHoraInicio.Year == anioActual &&
                                    h.TipoHora == "100%")
                        .Sum(h => h.CantidadHoras),
                    Horas50Anterior = e.HorasExtras
                        .Where(h => h.FechaHoraInicio.Month == mesAnterior &&
                                    h.FechaHoraInicio.Year == anioMesAnterior &&
                                    h.TipoHora == "50%")
                        .Sum(h => h.CantidadHoras),
                    Horas100Anterior = e.HorasExtras
                        .Where(h => h.FechaHoraInicio.Month == mesAnterior &&
                                    h.FechaHoraInicio.Year == anioMesAnterior &&
                                    h.TipoHora == "100%")
                        .Sum(h => h.CantidadHoras)
                })
                .ToListAsync();

            return Json(empleados);
        }

    }
}
