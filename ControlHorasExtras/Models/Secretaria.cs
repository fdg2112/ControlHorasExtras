using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

namespace ControlHorasExtras.Models;

public partial class Secretaria
{
    [Key]
    [Column("SecretariaID")]
    public int SecretariaId { get; set; }

    [StringLength(100)]
    public string NombreSecretaria { get; set; } = null!;

    [InverseProperty("Secretaria")]
    public virtual ICollection<Area> Areas { get; set; } = new List<Area>();

    [InverseProperty("Secretaria")]
    public virtual ICollection<Empleado> Empleados { get; set; } = new List<Empleado>();

    [InverseProperty("Secretaria")]
    public virtual ICollection<HorasExtra> HorasExtras { get; set; } = new List<HorasExtra>();

    [InverseProperty("Secretaria")]
    public virtual ICollection<Usuario> Usuarios { get; set; } = new List<Usuario>();
}
