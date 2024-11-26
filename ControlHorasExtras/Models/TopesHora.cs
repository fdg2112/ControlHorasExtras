using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

namespace ControlHorasExtras.Models;

public partial class TopesHora
{
    [Key]
    [Column("TopeHoraID")]
    public int TopeHoraId { get; set; }

    public int Mes { get; set; }

    public int Año { get; set; }

    [Column("AreaID")]
    public int AreaId { get; set; }

    public int TopeHoras { get; set; }

    [ForeignKey("AreaId")]
    [InverseProperty("TopesHoras")]
    public virtual Area Area { get; set; } = null!;
}
