using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using System.Linq;
using System.Threading.Tasks;
using ControlHorasExtras.Data;
using Microsoft.AspNetCore.Authorization;
using ControlHorasExtras.Models;
using static System.Runtime.InteropServices.JavaScript.JSType;

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
            int? areaId = areaIdClaim != null ? int.Parse(areaIdClaim.Value) : (int?)null;
            int? secretariaId = secretariaIdClaim != null ? int.Parse(secretariaIdClaim.Value) : (int?)null;

            // Filtrar los datos según el rol
            IQueryable<HorasExtra> query = _context.HorasExtras;

            if (rol == "Jefe de Área" && areaId.HasValue)
            {
                query = query.Where(h => h.AreaId == areaId);
            }
            else if (rol == "Secretario" && secretariaId.HasValue)
            {
                query = query.Where(h => h.SecretariaId == secretariaId);
            }

            // Verificar datos del query antes de continuar
            Console.WriteLine($"Rol: {rol}, AreaId: {areaId}, SecretariaId: {secretariaId}");
            Console.WriteLine($"Registros filtrados: {await query.CountAsync()}");

            // Obtener datos del mes actual
            var inicioMes = new DateTime(DateTime.Now.Year, DateTime.Now.Month, 1);
            var finMes = inicioMes.AddMonths(1).AddTicks(-1);

            var horasDelMes = await query
                .Where(h => h.FechaHoraInicio >= inicioMes && h.FechaHoraInicio <= finMes)
                .SumAsync(h => EF.Functions.DateDiffHour(h.FechaHoraInicio, h.FechaHoraFin));

            var gastoDelMes = await query
                .Where(h => h.FechaHoraInicio >= inicioMes && h.FechaHoraInicio <= finMes)
                .SumAsync(h => EF.Functions.DateDiffHour(h.FechaHoraInicio, h.FechaHoraFin) * (h.TipoHora == "50" ? 1.5 : 2.0));

            // Logs para verificar valores calculados
            Console.WriteLine($"Horas del Mes: {horasDelMes}");
            Console.WriteLine($"Gasto del Mes: {gastoDelMes}");

            // Preparar datos para la vista
            ViewData["HorasDelMes"] = horasDelMes;
            ViewData["GastoDelMes"] = gastoDelMes;

            return View();
        }

        //public async Task<IActionResult> Index()
        //{
        //    // Obtener los claims del usuario logueado
        //    var usuarioIdClaim = User.FindFirst("UsuarioId");
        //    var rolClaim = User.FindFirst("Rol");
        //    var nombreClaim = User.FindFirst("Nombre");
        //    var apellidoClaim = User.FindFirst("Apellido");
        //    var areaIdClaim = User.FindFirst("AreaId");
        //    var secretariaIdClaim = User.FindFirst("SecretariaId");
        //    if (usuarioIdClaim == null || rolClaim == null)
        //    {
        //        return Unauthorized(); // Redirigir a una página de error o al login
        //    }

        //    // Parsear los valores de los claims
        //    var usuarioId = int.Parse(usuarioIdClaim.Value);
        //    var rol = rolClaim.Value;
        //    var nombre = nombreClaim.Value;
        //    var apellido = apellidoClaim.Value;
        //    var areaId = int.Parse(areaIdClaim.Value);
        //    var secretariaId = int.Parse(secretariaIdClaim.Value);

        //    // Filtrar los datos según el rol
        //    IQueryable<HorasExtra> query = _context.HorasExtras;

        //    if (rol == "Jefe de Área")
        //    {
        //        var areaID = await _context.Usuarios
        //            .Where(u => u.UsuarioId == usuarioId)
        //            .Select(u => u.AreaId)
        //            .FirstOrDefaultAsync();

        //        query = query.Where(h => h.AreaId == areaID);
        //    }
        //    else if (rol == "Secretario")
        //    {
        //        var secretariaID = await _context.Usuarios
        //            .Where(u => u.UsuarioId == usuarioId)
        //            .Select(u => u.SecretariaId)
        //            .FirstOrDefaultAsync();

        //        query = query.Where(h => h.SecretariaId == secretariaID);
        //    }

        //    // Obtener datos del dashboard
        //    var horasDelMes = await query
        //        .Where(h => h.FechaHoraInicio.Month == DateTime.Now.Month && h.FechaHoraInicio.Year == DateTime.Now.Year)
        //        .SumAsync(h => EF.Functions.DateDiffHour(h.FechaHoraInicio, h.FechaHoraFin));

        //    var gastoDelMes = await query
        //        .Where(h => h.FechaHoraInicio.Month == DateTime.Now.Month && h.FechaHoraInicio.Year == DateTime.Now.Year)
        //        .SumAsync(h => EF.Functions.DateDiffHour(h.FechaHoraInicio, h.FechaHoraFin) * (h.TipoHora == "50" ? 1.5 : 2.0));

        //    // Preparar datos para la vista
        //    ViewData["HorasDelMes"] = horasDelMes;
        //    ViewData["GastoDelMes"] = gastoDelMes;
        //    ViewData["Nombre"] = nombreClaim;

        //    return View();
        //}


    }
}
