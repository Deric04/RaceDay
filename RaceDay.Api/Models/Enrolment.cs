
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace RaceDay.Api.Models;

[Table("Enrolments")]
public class Enrolment
{
    [Key]
    public int EnrolmentID { get; set; }

    public int ParticipantID { get; set; }

    public int EventCategoryID { get; set; }

    public DateTime EnrolmentDate { get; set; }

    [Required, MaxLength(30)]
    public string EnrolmentStatus { get; set; } = "Confirmed";

    [ForeignKey(nameof(ParticipantID))]
    public Participant? Participant { get; set; }

    [ForeignKey(nameof(EventCategoryID))]
    public EventCategory? EventCategory { get; set; }
}
