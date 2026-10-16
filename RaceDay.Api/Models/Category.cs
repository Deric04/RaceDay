
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace RaceDay.Api.Models;

[Table("Categories")]
public class Category
{
    [Key]
    public int CategoryID { get; set; }

    [Required, MaxLength(100)]
    public string CategoryName { get; set; } = string.Empty;

    [Column(TypeName = "decimal(5,2)")]
    public decimal DistanceKm { get; set; }

    public int MinimumAge { get; set; }

    public int? MaximumAge { get; set; }
}
