using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

namespace ControlHorasExtras.Models;

public partial class Role
{
    [Key]
    [Column("RolID")]
    public int RolId { get; set; }

    [StringLength(100)]
    public string NombreRol { get; set; } = null!;

    [InverseProperty("Rol")]
    public virtual ICollection<Usuario> Usuarios { get; set; } = new List<Usuario>();
}
