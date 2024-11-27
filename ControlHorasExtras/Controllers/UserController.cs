using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using System.Threading.Tasks;
using System.Linq;
using ControlHorasExtras.Models;
using ControlHorasExtras.Data;

namespace ControlHorasExtras.Controllers
{
    public class UserController : Controller
    {
        private readonly ControlHorasExtrasContext _context;

        public UserController(ControlHorasExtrasContext context)
        {
            _context = context;
        }

        // Listar usuarios
        public async Task<IActionResult> Index()
        {
            var usuarios = await _context.Usuarios
                .Include(u => u.Rol)
                .Include(u => u.Area)
                .Include(u => u.Secretaria)
                .ToListAsync();
            return View(usuarios);
        }

        // Crear nuevo usuario (GET)
        public IActionResult Create()
        {
            ViewData["Roles"] = _context.Roles.ToList();
            ViewData["Areas"] = _context.Areas.ToList();
            ViewData["Secretarias"] = _context.Secretarias.ToList();
            return View();
        }

        // Crear nuevo usuario (POST)
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Create(Usuario usuario)
        {
            if (ModelState.IsValid)
            {
                _context.Add(usuario);
                await _context.SaveChangesAsync();
                return RedirectToAction(nameof(Index));
            }
            ViewData["Roles"] = _context.Roles.ToList();
            ViewData["Areas"] = _context.Areas.ToList();
            ViewData["Secretarias"] = _context.Secretarias.ToList();
            return View(usuario);
        }

        // Detalles de un usuario
        public async Task<IActionResult> Details(int id)
        {
            var usuario = await _context.Usuarios
                .Include(u => u.Rol)
                .Include(u => u.Area)
                .Include(u => u.Secretaria)
                .FirstOrDefaultAsync(u => u.UsuarioId == id);
            if (usuario == null) return NotFound();
            return View(usuario);
        }

        // Editar usuario (GET)
        public async Task<IActionResult> Edit(int id)
        {
            var usuario = await _context.Usuarios.FindAsync(id);
            if (usuario == null) return NotFound();

            ViewData["Roles"] = _context.Roles.ToList();
            ViewData["Areas"] = _context.Areas.ToList();
            ViewData["Secretarias"] = _context.Secretarias.ToList();
            return View(usuario);
        }

        // Editar usuario (POST)
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Edit(int id, Usuario usuario)
        {
            if (id != usuario.UsuarioId) return NotFound();

            if (ModelState.IsValid)
            {
                try
                {
                    _context.Update(usuario);
                    await _context.SaveChangesAsync();
                }
                catch (DbUpdateConcurrencyException)
                {
                    if (!_context.Usuarios.Any(u => u.UsuarioId == id))
                        return NotFound();
                    else throw;
                }
                return RedirectToAction(nameof(Index));
            }
            ViewData["Roles"] = _context.Roles.ToList();
            ViewData["Areas"] = _context.Areas.ToList();
            ViewData["Secretarias"] = _context.Secretarias.ToList();
            return View(usuario);
        }

        // Eliminar usuario
        public async Task<IActionResult> Delete(int id)
        {
            var usuario = await _context.Usuarios.FindAsync(id);
            if (usuario == null) return NotFound();

            _context.Usuarios.Remove(usuario);
            await _context.SaveChangesAsync();
            return RedirectToAction(nameof(Index));
        }
    }
}
