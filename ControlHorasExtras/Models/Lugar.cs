using System;
using System.Collections.Generic;

namespace ControlHorasExtras.Models;

public partial class Lugar
{
    public int LugarId { get; set; }

    public string NombreLugar { get; set; } = null!;

    public virtual ICollection<Actividad> Actividades { get; set; } = new List<Actividad>();
}
