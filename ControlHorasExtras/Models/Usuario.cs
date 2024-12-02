using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

namespace ControlHorasExtras.Models;

[Index("NombreUsuario", Name = "UQ__Usuarios__6B0F5AE035F9239D", IsUnique = true)]
public partial class Usuario
{
    [Key]
    [Column("UsuarioID")]
    public int UsuarioId { get; set; }

    [StringLength(100)]
    [Required(ErrorMessage = "El nombre de usuario es obligatorio.")]
    public string NombreUsuario { get; set; } = string.Empty;

    [StringLength(255)]
    [Required(ErrorMessage = "La contraseña es obligatoria.")]
    [DataType(DataType.Password)]
    public string Contraseña { get; set; } = string.Empty;

    [StringLength(50)]
    public string Nombre { get; set; } = string.Empty;

    [StringLength(50)]
    public string Apellido { get; set; } = string.Empty;

    [Column("RolID")]
    public int RolId { get; set; }

    [Column("AreaID")]
    public int? AreaId { get; set; }

    [Column("SecretariaID")]
    public int? SecretariaId { get; set; }

    [ForeignKey("AreaId")]
    [InverseProperty("Usuarios")]
    public virtual Area? Area { get; set; }

    [InverseProperty("Usuario")]
    public virtual ICollection<AuditoriaLogin> AuditoriaLogins { get; set; } = new List<AuditoriaLogin>();

    [ForeignKey("RolId")]
    [InverseProperty("Usuarios")]
    public virtual Rol Rol { get; set; } = null!;

    [ForeignKey("SecretariaId")]
    [InverseProperty("Usuarios")]
    public virtual Secretaria? Secretaria { get; set; }

    public Usuario()
    {
        // Inicialización para evitar advertencias
        NombreUsuario = string.Empty;
        Contraseña = string.Empty;
        Nombre = string.Empty;
        Apellido = string.Empty;
        AuditoriaLogins = new List<AuditoriaLogin>();
    }
}
