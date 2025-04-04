using ControlHorasExtras.Data;
using Microsoft.EntityFrameworkCore;
using Microsoft.AspNetCore.Components.Server.Circuits;
using ControlHorasExtras.Services;

var builder = WebApplication.CreateBuilder(args);

// Agregar servicios de autenticaci�n (usando Cookies)
builder.Services.AddAuthentication("Cookies")
    .AddCookie(options =>
    {
        options.LoginPath = "/Account/Login";
        options.LogoutPath = "/Account/Logout";
    });

// Otros servicios
builder.Services.AddControllersWithViews();
builder.Services.AddDbContext<OvertimeControlContext>(options =>
    options.UseSqlServer(builder.Configuration.GetConnectionString("DefaultConnection")));

// Agrega IHttpContextAccessor
builder.Services.AddHttpContextAccessor();

// Servicio de CustomCircuitHandler
builder.Services.AddSingleton<CircuitHandler, CustomCircuitHandler>();

var app = builder.Build();

// Pipeline de la aplicaci�n
if (!app.Environment.IsDevelopment())
{
    app.UseExceptionHandler("/Home/Error");
    app.UseHsts();
}

app.UseHttpsRedirection();
app.UseRouting();

// Middleware de autenticaci�n
app.UseAuthentication();
app.UseAuthorization();

app.MapStaticAssets();

app.MapControllerRoute(
    name: "default",
    pattern: "{controller=Account}/{action=Login}/{id?}")
    .WithStaticAssets();

app.Run();
