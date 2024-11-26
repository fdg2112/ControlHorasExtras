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
    public string NombreUsuario { get; set; } = null!;

    [StringLength(255)]
    public string Contraseña { get; set; } = null!;

    [StringLength(50)]
    public string Nombre { get; set; } = null!;

    [StringLength(50)]
    public string Apellido { get; set; } = null!;

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
    public virtual Role Rol { get; set; } = null!;

    [ForeignKey("SecretariaId")]
    [InverseProperty("Usuarios")]
    public virtual Secretaria? Secretaria { get; set; }
}
