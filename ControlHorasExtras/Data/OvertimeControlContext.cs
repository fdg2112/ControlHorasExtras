using ControlHorasExtras.Models;
using Microsoft.EntityFrameworkCore;

namespace ControlHorasExtras.Data;

public partial class OvertimeControlContext : DbContext
{
    public OvertimeControlContext()
    {
    }

    public OvertimeControlContext(DbContextOptions<OvertimeControlContext> options)
        : base(options)
    {
    }

    public virtual DbSet<ActividadesTrabajo> ActividadesTrabajos { get; set; }
    public virtual DbSet<Area> Areas { get; set; } = null!;
    public virtual DbSet<AuditoriaLogin> AuditoriaLogins { get; set; } = null!;
    public virtual DbSet<CategoriasSalariales> CategoriasSalariales { get; set; } = null!;
    public virtual DbSet<Empleado> Empleados { get; set; } = null!;
    public virtual DbSet<HorasExtra> HorasExtras { get; set; } = null!;
    public virtual DbSet<LugaresTrabajo> LugaresTrabajos { get; set; } = null!;
    public virtual DbSet<Rol> Roles { get; set; } = null!;
    public virtual DbSet<Secretaria> Secretarias { get; set; } = null!;
    public virtual DbSet<TopesHora> TopesHoras { get; set; } = null!;
    public virtual DbSet<Usuario> Usuarios { get; set; } = null!;
    public virtual DbSet<VistaGastosHorasExtras> VistaGastosHorasExtras { get; set; }


    protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
        => optionsBuilder.UseSqlServer("Data Source=ESTA-PC\\SQLEXPRESS;Initial Catalog=OvertimeControl;Integrated Security=True;Encrypt=False");

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        modelBuilder.Entity<ActividadesTrabajo>(entity =>
        {
            entity.HasKey(e => e.ActividadId).HasName("PK__Activida__981483F0D82D8843");

            entity.ToTable("ActividadesTrabajo");

            entity.Property(e => e.ActividadId).HasColumnName("ActividadID");
            entity.Property(e => e.LugarId).HasColumnName("LugarID");
            entity.Property(e => e.NombreActividad).HasMaxLength(100);
        });

        modelBuilder.Entity<Area>(entity =>
        {
            entity.HasKey(e => e.AreaId).HasName("PK__Areas__70B8202883BF80F8");

            entity.HasOne(d => d.Secretaria).WithMany(p => p.Areas)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__Areas__Secretari__3B75D760");
        });

        modelBuilder.Entity<AuditoriaLogin>(entity =>
        {
            entity.HasKey(e => e.LoginId).HasName("PK__Auditori__4DDA28386986AF7E");

            entity.Property(e => e.FechaHoraLogin).HasDefaultValueSql("(getdate())");

            entity.HasOne(d => d.Usuario).WithMany(p => p.AuditoriaLogins)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__Auditoria__Usuar__5812160E");
        });

        modelBuilder.Entity<CategoriasSalariales>(entity =>
        {
            entity.HasKey(e => e.CategoriaId).HasName("PK__Categori__F353C1C5FF775B23");
        });

        modelBuilder.Entity<Empleado>(entity =>
        {
            entity.HasKey(e => e.EmpleadoId).HasName("PK__Empleado__958BE6F025634A7A");

            entity.ToTable(tb => tb.HasTrigger("trg_ValidarAreaSecretaria_Empleado"));

            entity.HasOne(d => d.Area).WithMany(p => p.Empleados).HasConstraintName("FK__Empleados__AreaI__48CFD27E");

            entity.HasOne(d => d.Categoria).WithMany(p => p.Empleados)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__Empleados__Categ__4AB81AF0");

            entity.HasOne(d => d.Secretaria).WithMany(p => p.Empleados)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__Empleados__Secre__49C3F6B7");
        });

        modelBuilder.Entity<HorasExtra>(entity =>
        {
            entity.HasKey(e => e.HoraExtraId).HasName("PK__HorasExt__BEE2482F70673057");

            entity.ToTable(tb => tb.HasTrigger("trg_ValidarAreaSecretaria_HorasExtras"));

            entity.Property(e => e.HoraExtraId).HasColumnName("HoraExtraID");
            entity.Property(e => e.ActividadId).HasColumnName("ActividadID");
            entity.Property(e => e.AreaId).HasColumnName("AreaID");
            entity.Property(e => e.CantidadHoras).HasComputedColumnSql("(datediff(hour,[FechaHoraInicio],[FechaHoraFin]))", false);
            entity.Property(e => e.EmpleadoId).HasColumnName("EmpleadoID");
            entity.Property(e => e.FechaHoraFin).HasColumnType("datetime");
            entity.Property(e => e.FechaHoraInicio).HasColumnType("datetime");
            entity.Property(e => e.SecretariaId).HasColumnName("SecretariaID");
            entity.Property(e => e.TipoHora).HasMaxLength(50);

            entity.HasOne(d => d.Area).WithMany(p => p.HorasExtras)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__HorasExtr__AreaI__4F7CD00D");

            entity.HasOne(d => d.Empleado).WithMany(p => p.HorasExtras)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__HorasExtr__Emple__4E88ABD4");

            entity.HasOne(d => d.Secretaria).WithMany(p => p.HorasExtras)
                .HasForeignKey(d => d.SecretariaId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__HorasExtr__Secre__5070F446");
        });


        modelBuilder.Entity<LugaresTrabajo>(entity =>
        {
            entity.HasKey(e => e.LugarId).HasName("PK__LugaresT__1BDE0D808AA4CB5E");

            entity.ToTable("LugaresTrabajo");

            entity.Property(e => e.LugarId).HasColumnName("LugarID");
            entity.Property(e => e.NombreLugar).HasMaxLength(100);
        });

        modelBuilder.Entity<Rol>(entity =>
        {
            entity.HasKey(e => e.RolId).HasName("PK__Roles__F92302D109A1162F");
        });

        modelBuilder.Entity<Secretaria>(entity =>
        {
            entity.HasKey(e => e.SecretariaId).HasName("PK__Secretar__94C9862E3F8CC0E3");
        });

        modelBuilder.Entity<TopesHora>(entity =>
        {
            entity.HasKey(e => e.TopeHoraId).HasName("PK__TopesHor__9F964E5BC2B142E6");

            entity.HasOne(d => d.Area).WithMany(p => p.TopesHoras)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__TopesHora__AreaI__5441852A");
        });

        modelBuilder.Entity<Usuario>(entity =>
        {
            entity.HasKey(e => e.UsuarioId).HasName("PK__Usuarios__2B3DE798F6FF05B6");

            entity.HasOne(d => d.Area).WithMany(p => p.Usuarios).HasConstraintName("FK__Usuarios__AreaID__4222D4EF");

            entity.HasOne(d => d.Rol).WithMany(p => p.Usuarios)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__Usuarios__RolID__440B1D61");

            entity.HasOne(d => d.Secretaria).WithMany(p => p.Usuarios).HasConstraintName("FK__Usuarios__Secret__4316F928");
        });

        modelBuilder.Entity<VistaGastosHorasExtras>(entity =>
        {
            entity.HasNoKey(); // Las vistas no tienen clave primaria
            entity.ToView("VistaGastosHorasExtras"); // Nombre exacto de la vista en SQL
        });
        OnModelCreatingPartial(modelBuilder);
    }

    partial void OnModelCreatingPartial(ModelBuilder modelBuilder);
}
