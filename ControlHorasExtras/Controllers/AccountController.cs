using Microsoft.AspNetCore.Mvc;
using System.Security.Claims;
using Microsoft.AspNetCore.Authentication;
using Microsoft.EntityFrameworkCore;
using ControlHorasExtras.Models;
using ControlHorasExtras.Data;

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
                        // Auditoría de login
                        var auditoriaLogin = new AuditoriaLogin
                        {
                            UsuarioId = usuario.UsuarioId,
                            FechaHoraLogin = DateTime.Now,
                            Ip = HttpContext.Connection.RemoteIpAddress?.ToString()
                        };
                        _context.AuditoriaLogins.Add(auditoriaLogin);
                        await _context.SaveChangesAsync();

                        // Claims para la sesión del usuario
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

                        // Inicia sesión con el esquema de cookies
                        await HttpContext.SignInAsync("Cookies", principal);

                        return RedirectToAction("Index", "Dashboard");
                    }
                    else ModelState.AddModelError("", "Nombre de usuario o contraseña incorrectos.");
                }
                catch (Exception ex)
                {
                    // Manejo de excepciones
                    ModelState.AddModelError("", "Error al intentar iniciar sesión. Por favor, inténtelo de nuevo más tarde.");
                    // Loguear el error
                    _logger.LogError(ex, "Error al intentar iniciar sesión.");
                }
            }
            return View(model);
        }

        public IActionResult Create()
        {
            // Obtener el AreaId del usuario logueado desde los claims
            var areaIdClaim = User.FindFirst("AreaId");

            if (areaIdClaim == null)
            {
                // Si no se encuentra el AreaId en los claims, redirigir o mostrar un error
                return Unauthorized(); // O redirigir a alguna página de error
            }

            var areaId = int.Parse(areaIdClaim.Value);  // Convertir el AreaId a entero

            // Filtrar los empleados según el área del usuario logueado
            var empleados = _context.Empleados
                .Where(e => e.AreaId == areaId)  // Filtrar empleados por el AreaId del usuario
                .ToList();

            // Pasar los empleados filtrados a la vista
            ViewData["Empleados"] = empleados;

            return View();
        }

        // Logout
        public async Task<IActionResult> Logout()
        {
            await HttpContext.SignOutAsync();
            return RedirectToAction("Login");
        }
    }
}
