using ControlHorasExtras.Data;
using Microsoft.EntityFrameworkCore;
using Microsoft.AspNetCore.Components.Server.Circuits;
using ControlHorasExtras.Services;

var builder = WebApplication.CreateBuilder(args);

// Agregar servicios de autenticaci�n (usando Cookies)
builder.Services.AddAuthentication("Cookies")
    .AddCookie(options =>
    {
        options.LoginPath = "/Account/Login";  // Ruta a la que redirigir cuando no est� autenticado
        options.LogoutPath = "/Account/Logout";  // Ruta para cerrar sesi�n
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

// Configurar el pipeline de la aplicaci�n
if (!app.Environment.IsDevelopment())
{
    app.UseExceptionHandler("/Home/Error");
    app.UseHsts();
}

app.UseHttpsRedirection();
app.UseRouting();

// A�adir el middleware de autenticaci�n
app.UseAuthentication();  // Este middleware debe ir antes de UseAuthorization
app.UseAuthorization();

app.MapStaticAssets();

app.MapControllerRoute(
    name: "default",
    pattern: "{controller=Account}/{action=Login}/{id?}")
    .WithStaticAssets();

app.Run();
