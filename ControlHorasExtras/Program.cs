using ControlHorasExtras.Data;
using Microsoft.EntityFrameworkCore;
using Microsoft.AspNetCore.Components.Server.Circuits;
using ControlHorasExtras.Services;

var builder = WebApplication.CreateBuilder(args);

// Agregar servicios de autenticación (usando Cookies)
builder.Services.AddAuthentication("Cookies")
    .AddCookie(options =>
    {
        options.LoginPath = "/Account/Login";  // Ruta a la que redirigir cuando no esté autenticado
        options.LogoutPath = "/Account/Logout";  // Ruta para cerrar sesión
    });

// Otros servicios
builder.Services.AddControllersWithViews();
builder.Services.AddDbContext<OvertimeControlContext>(options =>
    options.UseSqlServer(builder.Configuration.GetConnectionString("DefaultConnection")));

// Agrega IHttpContextAccessor
builder.Services.AddHttpContextAccessor();
// Agrega el servicio de CustomCircuitHandler
builder.Services.AddSingleton<CircuitHandler, CustomCircuitHandler>();

var app = builder.Build();

// Configurar el pipeline de la aplicación
if (!app.Environment.IsDevelopment())
{
    app.UseExceptionHandler("/Home/Error");
    app.UseHsts();
}

app.UseHttpsRedirection();
app.UseRouting();

// Añadir el middleware de autenticación
app.UseAuthentication();  // Este middleware debe ir antes de UseAuthorization
app.UseAuthorization();

app.MapStaticAssets();

app.MapControllerRoute(
    name: "default",
    pattern: "{controller=Account}/{action=Login}/{id?}")
    .WithStaticAssets();

app.Run();
