using System;
using System.Collections.Generic;

namespace ControlHorasExtras.Models;

public partial class CategoriasSalariale
{
    public int CategoriaId { get; set; }

    public int NombreCategoria { get; set; }

    public decimal? SueldoBasico { get; set; }

    public DateOnly? DesdeMes { get; set; }

    public DateOnly? HastaMes { get; set; }

    public virtual ICollection<AumentosParitaria> AumentosParitaria { get; set; } = new List<AumentosParitaria>();

    public virtual ICollection<Empleado> Empleados { get; set; } = new List<Empleado>();

    public virtual ICollection<Salario> Salarios { get; set; } = new List<Salario>();
}
