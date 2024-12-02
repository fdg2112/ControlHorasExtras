using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Configuration;
using System.Linq;
using System.Security.Claims;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Authentication;
using Microsoft.AspNetCore.Authorization;
using Microsoft.EntityFrameworkCore;
using ControlHorasExtras.Models;
using ControlHorasExtras.Data;  // Reemplazar con tu modelo adecuado

namespace ControlHorasExtras.Controllers
{
    public class AccountController : Controller
    {
        private readonly OvertimeControlContext _context;

        public AccountController(OvertimeControlContext context)
        {
            _context = context;
        }

        // Vista de login
        [HttpGet]
        public IActionResult Login()
        {
            return View();
        }

        // Acción para el login
        [HttpPost]
        public async Task<IActionResult> Login(LoginViewModel model)
        {
            if (ModelState.IsValid)
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

                    // Crear Claims para la sesión del usuario
                    var claims = new List<Claim>
            {
                new Claim(ClaimTypes.Name, usuario.NombreUsuario),
                new Claim("Rol", usuario.Rol.NombreRol),
                new Claim("UsuarioId", usuario.UsuarioId.ToString())
            };

                    var identity = new ClaimsIdentity(claims, "Cookies"); // Especificamos el esquema 'Cookies'
                    var principal = new ClaimsPrincipal(identity);
                    await HttpContext.SignInAsync("Cookies", principal);  // Especificamos 'Cookies' aquí también

                    // Redirección según el rol del usuario
                    if (usuario.Rol.NombreRol == "Jefe de Área")
                        return RedirectToAction("Index", "Area");
                    else if (usuario.Rol.NombreRol == "Secretario")
                        return RedirectToAction("Index", "Secretaria");
                    else if (usuario.Rol.NombreRol == "Secretario Hacienda")
                        return RedirectToAction("Index", "Hacienda");
                    else if (usuario.Rol.NombreRol == "Intendente")
                        return RedirectToAction("Index", "Intendente");
                    else
                    {
                        // Si el rol no coincide con los anteriores, redirige al Dashboard
                        return RedirectToAction("Index", "Dashboard");
                    }
                }
                else
                {
                    ModelState.AddModelError("", "Nombre de usuario o contraseña incorrectos.");
                }
            }
            return View(model);
        }


        // Logout
        public async Task<IActionResult> Logout()
        {
            await HttpContext.SignOutAsync();
            return RedirectToAction("Login");
        }
    }
}
