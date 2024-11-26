using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

namespace ControlHorasExtras.Models;

public partial class Area
{
    [Key]
    [Column("AreaID")]
    public int AreaId { get; set; }

    [StringLength(100)]
    public string NombreArea { get; set; } = null!;

    [Column("SecretariaID")]
    public int SecretariaId { get; set; }

    [InverseProperty("Area")]
    public virtual ICollection<Empleado> Empleados { get; set; } = new List<Empleado>();

    [InverseProperty("Area")]
    public virtual ICollection<HorasExtra> HorasExtras { get; set; } = new List<HorasExtra>();

    [ForeignKey("SecretariaId")]
    [InverseProperty("Areas")]
    public virtual Secretaria Secretaria { get; set; } = null!;

    [InverseProperty("Area")]
    public virtual ICollection<TopesHora> TopesHoras { get; set; } = new List<TopesHora>();

    [InverseProperty("Area")]
    public virtual ICollection<Usuario> Usuarios { get; set; } = new List<Usuario>();
}
