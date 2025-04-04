using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Configuration;
using System.Linq;
using System.Security.Claims;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Authentication;
using Microsoft.AspNetCore.Authorization;
using Microsoft.EntityFrameworkCore;
using ControlHorasExtras.Models;
using ControlHorasExtras.Data;
using Microsoft.Extensions.Logging;


namespace ControlHorasExtras.Controllers
{
    public class AccountController : Controller
    {
        private readonly OvertimeControlContext _context;
        private readonly ILogger<AccountController> _logger;

        public AccountController(OvertimeControlContext context, ILogger<AccountController> logger)
        {
            _context = context;
            _logger = logger;
        }

        [HttpGet]
        public IActionResult Login()
        {
            return View();
        }

        [HttpPost]
        public async Task<IActionResult> Login(LoginViewModel model)
        {
            if (ModelState.IsValid)
            {
                try
                {
                    var usuario = await _context.Usuarios
                        .Include(u => u.Rol)
                        .FirstOrDefaultAsync(u => u.NombreUsuario == model.NombreUsuario);
                    if (usuario != null && usuario.Contraseña == model.Contraseña)
                    {
                        var auditoriaLogin = new AuditoriaLogin
                        {
                            UsuarioId = usuario.UsuarioId,
                            FechaHoraLogin = DateTime.Now,
                            Ip = HttpContext.Connection.RemoteIpAddress?.ToString()
                        };
                        _context.AuditoriaLogins.Add(auditoriaLogin);
                        await _context.SaveChangesAsync();

                        var claims = new List<Claim>
                        {
                            new Claim(ClaimTypes.Name, usuario.NombreUsuario),
                            new Claim("Nombre", usuario.Nombre),
                            new Claim("Apellido", usuario.Apellido),
                            new Claim("UsuarioId", usuario.UsuarioId.ToString()),
                            new Claim("Rol", usuario.Rol.NombreRol),
                            new Claim("AreaId", usuario.AreaId.ToString()),
                            new Claim("SecretariaId", usuario.SecretariaId.ToString())
                        };
                        var identity = new ClaimsIdentity(claims, "Cookies");
                        var principal = new ClaimsPrincipal(identity);

                        await HttpContext.SignInAsync("Cookies", principal);

                        return RedirectToAction("Index", "Dashboard");
                    }
                    else ModelState.AddModelError("", "Nombre de usuario o contraseña incorrectos.");
                }
                catch (Exception ex)
                {
                    ModelState.AddModelError("", "Error al intentar iniciar sesión. Por favor, inténtelo de nuevo más tarde.");
                    _logger.LogError(ex, "Error al intentar iniciar sesión.");
                }
            }
            return View(model);
        }

        public IActionResult Create()
        {
            var areaIdClaim = User.FindFirst("AreaId");

            if (areaIdClaim == null)
            {
                return Unauthorized();
            }

            var areaId = int.Parse(areaIdClaim.Value);
            var empleados = _context.Empleados
                .Where(e => e.AreaId == areaId) 
                .ToList();

            ViewData["Empleados"] = empleados;

            return View();
        }
        public async Task<IActionResult> Logout()
        {
            await HttpContext.SignOutAsync();
            return RedirectToAction("Login");
        }
    }
}
