using System;
using System.Collections.Generic;

namespace ControlHorasExtras.Models;

public partial class Paritaria
{
    public int ParitariaId { get; set; }

    public int DecretoNumero { get; set; }

    public DateOnly FechaPublicacion { get; set; }

    public virtual ICollection<AumentosParitaria> AumentosParitaria { get; set; } = new List<AumentosParitaria>();

    public virtual ICollection<Salario> Salarios { get; set; } = new List<Salario>();
}
