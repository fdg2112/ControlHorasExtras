using System;
using System.Collections.Generic;

namespace ControlHorasExtras.Models;

public partial class Actividad
{
    public int ActividadId { get; set; }

    public string NombreActividad { get; set; } = null!;

    public string Lugar { get; set; } = null!;

    public int? AreaId { get; set; }

    public int SecretariaId { get; set; }

    public int? LugarId { get; set; }

    public virtual Area? Area { get; set; }

    public virtual ICollection<HorasExtra> HorasExtras { get; set; } = new List<HorasExtra>();

    public virtual Lugar? LugarNavigation { get; set; }

    public virtual Secretaria Secretaria { get; set; } = null!;
}
