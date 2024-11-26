using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

namespace ControlHorasExtras.Models;

public partial class AuditoriaLogin
{
    [Key]
    [Column("LoginID")]
    public int LoginId { get; set; }

    [Column("UsuarioID")]
    public int UsuarioId { get; set; }

    [Column(TypeName = "datetime")]
    public DateTime FechaHoraLogin { get; set; }

    [Column("IP")]
    [StringLength(50)]
    public string? Ip { get; set; }

    [ForeignKey("UsuarioId")]
    [InverseProperty("AuditoriaLogins")]
    public virtual Usuario Usuario { get; set; } = null!;
}
