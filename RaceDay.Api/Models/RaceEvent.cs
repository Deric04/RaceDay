
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace RaceDay.Api.Models;

[Table("Events")]
public class RaceEvent
{
    [Key]
    public int EventID { get; set; }

    public int OrganiserID { get; set; }

    public int VenueID { get; set; }

    [Required, MaxLength(150)]
    public string EventName { get; set; } = string.Empty;

    [MaxLength(500)]
    public string? EventDescription { get; set; }

    public DateTime EventDate { get; set; }

    public DateTime RegistrationDeadline { get; set; }

    [MaxLength(30)]
    public string Status { get; set; } = "Open";

    [ForeignKey(nameof(OrganiserID))]
    public Organiser? Organiser { get; set; }

    [ForeignKey(nameof(VenueID))]
    public Venue? Venue { get; set; }
}
