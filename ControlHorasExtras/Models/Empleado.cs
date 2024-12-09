using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

namespace ControlHorasExtras.Models;

[Index("Legajo", Name = "UQ__Empleado__0E01039A1E554AFA", IsUnique = true)]
public partial class Empleado
{
    [Key]
    [Column("EmpleadoID")]
    public int EmpleadoId { get; set; }

    public int Legajo { get; set; }

    [StringLength(100)]
    public string Nombre { get; set; } = null!;

    [StringLength(100)]
    public string Apellido { get; set; } = null!;

    [Column("AreaID")]
    public int? AreaId { get; set; }

    [Column("SecretariaID")]
    public int SecretariaId { get; set; }

    [Column("CategoriaID")]
    public int CategoriaId { get; set; }

    public DateOnly FechaIngreso { get; set; }

    [ForeignKey("AreaId")]
    [InverseProperty("Empleados")]
    public virtual Area? Area { get; set; }

    [ForeignKey("CategoriaId")]
    [InverseProperty("Empleados")]
    public virtual CategoriasSalariales Categoria { get; set; } = null!;

    [InverseProperty("Empleado")]
    public virtual ICollection<HorasExtra> HorasExtras { get; set; } = new List<HorasExtra>();

    [ForeignKey("SecretariaId")]
    [InverseProperty("Empleados")]
    public virtual Secretaria Secretaria { get; set; } = null!;
}
