using System;
using System.Collections.Generic;

namespace ControlHorasExtras.Models;

public partial class ActividadesTrabajo
{
    public int ActividadId { get; set; }

    public string NombreActividad { get; set; } = null!;

    public int LugarId { get; set; }
}
