using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

namespace ControlHorasExtras.Models;

public partial class CategoriasSalariales
{
    [Key]
    [Column("CategoriaID")]
    public int CategoriaId { get; set; }

    public int NombreCategoria { get; set; }

    [Column(TypeName = "decimal(10, 2)")]
    public decimal SueldoBasico { get; set; }

    public DateOnly DesdeMes { get; set; }

    public DateOnly? HastaMes { get; set; }

    [InverseProperty("Categoria")]
    public virtual ICollection<Empleado> Empleados { get; set; } = new List<Empleado>();
}
