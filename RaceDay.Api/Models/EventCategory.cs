
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace RaceDay.Api.Models;

[Table("EventCategories")]
public class EventCategory
{
    [Key]
    public int EventCategoryID { get; set; }

    public int EventID { get; set; }

    public int CategoryID { get; set; }

    [Column(TypeName = "decimal(10,2)")]
    public decimal EntryFee { get; set; }

    public int MaximumEntries { get; set; }

    [ForeignKey(nameof(EventID))]
    public RaceEvent? Event { get; set; }

    [ForeignKey(nameof(CategoryID))]
    public Category? Category { get; set; }
}
