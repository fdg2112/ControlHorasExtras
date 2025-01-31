using System;
using System.Collections.Generic;

namespace ControlHorasExtras.Models;

public partial class Salario
{
    public int SalarioId { get; set; }

    public int CategoriaId { get; set; }

    public int ParitariaId { get; set; }

    public DateOnly FechaDesde { get; set; }

    public decimal SueldoBasico { get; set; }

    public virtual CategoriasSalariale Categoria { get; set; } = null!;

    public virtual Paritaria Paritaria { get; set; } = null!;
}
