using System;
using System.Collections.Generic;
using ControlHorasExtras.Models;
using Microsoft.EntityFrameworkCore;

namespace ControlHorasExtras.Data;

public partial class ControlHorasExtrasContext : DbContext
{
    public ControlHorasExtrasContext()
    {
    }

    public ControlHorasExtrasContext(DbContextOptions<ControlHorasExtrasContext> options)
        : base(options)
    {
    }

    public virtual DbSet<Area> Areas { get; set; }

    public virtual DbSet<AuditoriaLogin> AuditoriaLogins { get; set; }

    public virtual DbSet<CategoriasSalariale> CategoriasSalariales { get; set; }

    public virtual DbSet<Empleado> Empleados { get; set; }

    public virtual DbSet<HorasExtra> HorasExtras { get; set; }

    public virtual DbSet<Role> Roles { get; set; }

    public virtual DbSet<Secretaria> Secretarias { get; set; }

    public virtual DbSet<TopesHora> TopesHoras { get; set; }

    public virtual DbSet<Usuario> Usuarios { get; set; }

    protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
#warning To protect potentially sensitive information in your connection string, you should move it out of source code. You can avoid scaffolding the connection string by using the Name= syntax to read it from configuration - see https://go.microsoft.com/fwlink/?linkid=2131148. For more guidance on storing connection strings, see https://go.microsoft.com/fwlink/?LinkId=723263.
        => optionsBuilder.UseSqlServer("Data Source=DESKTOP-4PEIPL5\\SQLEXPRESS;Initial Catalog=ControlHorasExtras;Integrated Security=True;Encrypt=False");

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
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

        modelBuilder.Entity<CategoriasSalariale>(entity =>
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
            entity.HasKey(e => e.HoraExtraId).HasName("PK__HorasExt__BEE2482FCADAE585");

            entity.ToTable(tb => tb.HasTrigger("trg_ValidarAreaSecretaria_HorasExtras"));

            entity.HasOne(d => d.Area).WithMany(p => p.HorasExtras)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__HorasExtr__AreaI__4F7CD00D");

            entity.HasOne(d => d.Empleado).WithMany(p => p.HorasExtras)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__HorasExtr__Emple__4E88ABD4");

            entity.HasOne(d => d.Secretaria).WithMany(p => p.HorasExtras)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__HorasExtr__Secre__5070F446");
        });

        modelBuilder.Entity<Role>(entity =>
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

        OnModelCreatingPartial(modelBuilder);
    }

    partial void OnModelCreatingPartial(ModelBuilder modelBuilder);
}
