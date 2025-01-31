using System;
using System.Collections.Generic;

namespace ControlHorasExtras.Models;

public partial class AumentosParitaria
{
    public int AumentoId { get; set; }

    public int ParitariaId { get; set; }

    public int CategoriaId { get; set; }

    public DateOnly FechaDesde { get; set; }

    public decimal PorcentajeAumento { get; set; }

    public virtual CategoriasSalariale Categoria { get; set; } = null!;

    public virtual Paritaria Paritaria { get; set; } = null!;
}
