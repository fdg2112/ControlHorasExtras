using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace ControlHorasExtras.Models;

public partial class HorasExtra
{
    [Key]
    [Column("HoraExtraID")]
    public int HoraExtraId { get; set; }

    [Column("EmpleadoID")]
    public int EmpleadoId { get; set; }

    [Column(TypeName = "datetime")]
    public DateTime FechaHoraInicio { get; set; }

    [Column(TypeName = "datetime")]
    public DateTime FechaHoraFin { get; set; }

    [DatabaseGenerated(DatabaseGeneratedOption.Computed)]
    public int CantidadHoras { get; set; }

    [StringLength(50)]
    public string TipoHora { get; set; } = null!;

    [Column("AreaID")]
    public int AreaId { get; set; }

    [Column("SecretariaID")]
    public int SecretariaId { get; set; }

    [ForeignKey("AreaId")]
    [InverseProperty("HorasExtras")]
    public virtual Area Area { get; set; } = null!;

    [ForeignKey("EmpleadoId")]
    [InverseProperty("HorasExtras")]
    public virtual Empleado Empleado { get; set; } = null!;

    [ForeignKey("SecretariaId")]
    [InverseProperty("HorasExtras")]
    public virtual Secretaria Secretaria { get; set; } = null!;
}
