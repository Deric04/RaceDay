
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using RaceDay.Api.Data;
using RaceDay.Api.Models;

namespace RaceDay.Api.Controllers;

[ApiController]
[Route("api/events")]
public class EventsController : ControllerBase
{
    private readonly RaceDayDbContext _db;

    public EventsController(RaceDayDbContext db)
    {
        _db = db;
    }

    // Public: view all events
    [HttpGet]
    [AllowAnonymous]
    public async Task<IActionResult> GetEvents()
    {
        var events = await _db.Events
            .AsNoTracking()
            .Select(e => new
            {
                e.EventID,
                e.EventName,
                e.EventDescription,
                e.EventDate,
                e.RegistrationDeadline,
                e.Status,
                e.VenueID,
                e.OrganiserID
            })
            .ToListAsync();

        return Ok(events);
    }

    // Public: view one event
    [HttpGet("{id:int}")]
    [AllowAnonymous]
    public async Task<IActionResult> GetEvent(int id)
    {
        var eventItem = await _db.Events
            .AsNoTracking()
            .Where(e => e.EventID == id)
            .Select(e => new
            {
                e.EventID,
                e.EventName,
                e.EventDescription,
                e.EventDate,
                e.RegistrationDeadline,
                e.Status,
                e.VenueID,
                e.OrganiserID
            })
            .FirstOrDefaultAsync();

        if (eventItem == null)
            return NotFound(new { message = "Event not found." });

        return Ok(eventItem);
    }

    // Organisers only: create event
    [HttpPost]
    [Authorize(Roles = "Organiser")]
    public async Task<IActionResult> CreateEvent(RaceEvent eventItem)
    {
        eventItem.EventID = 0;
        _db.Events.Add(eventItem);
        await _db.SaveChangesAsync();

        return CreatedAtAction(
            nameof(GetEvent),
            new { id = eventItem.EventID },
            new { eventItem.EventID, eventItem.EventName });
    }

    // Organisers only: update event
    [HttpPut("{id:int}")]
    [Authorize(Roles = "Organiser")]
    public async Task<IActionResult> UpdateEvent(int id, RaceEvent updatedEvent)
    {
        var eventItem = await _db.Events.FindAsync(id);

        if (eventItem == null)
            return NotFound(new { message = "Event not found." });

        eventItem.EventName = updatedEvent.EventName;
        eventItem.EventDescription = updatedEvent.EventDescription;
        eventItem.EventDate = updatedEvent.EventDate;
        eventItem.RegistrationDeadline = updatedEvent.RegistrationDeadline;
        eventItem.Status = updatedEvent.Status;
        eventItem.VenueID = updatedEvent.VenueID;

        await _db.SaveChangesAsync();

        return NoContent();
    }

    // Organisers only: delete event
    [HttpDelete("{id:int}")]
    [Authorize(Roles = "Organiser")]
    public async Task<IActionResult> DeleteEvent(int id)
    {
        var eventItem = await _db.Events.FindAsync(id);

        if (eventItem == null)
            return NotFound(new { message = "Event not found." });

        _db.Events.Remove(eventItem);
        await _db.SaveChangesAsync();

        return NoContent();
    }
}
