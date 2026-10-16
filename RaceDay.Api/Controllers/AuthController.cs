
using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using System.Text;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Microsoft.IdentityModel.Tokens;
using RaceDay.Api.Data;
using RaceDay.Api.Models;

namespace RaceDay.Api.Controllers;

[ApiController]
[Route("api/auth")]
public class AuthController : ControllerBase
{
    private readonly RaceDayDbContext _db;
    private readonly IConfiguration _configuration;
    private readonly PasswordHasher<Participant> _participantHasher = new();
    private readonly PasswordHasher<Organiser> _organiserHasher = new();

    public AuthController(
        RaceDayDbContext db,
        IConfiguration configuration)
    {
        _db = db;
        _configuration = configuration;
    }

    [HttpPost("register")]
    public async Task<IActionResult> Register(RegisterRequest request)
    {
        var email = request.Email.Trim().ToLowerInvariant();

        if (await _db.Participants.AnyAsync(p => p.Email.ToLower() == email) ||
            await _db.Organisers.AnyAsync(o => o.Email.ToLower() == email))
        {
            return Conflict(new { message = "An account with this email already exists." });
        }

        var participant = new Participant
        {
            FirstName = request.FirstName.Trim(),
            LastName = request.LastName.Trim(),
            Email = email,
            Phone = request.Phone,
            DateOfBirth = request.DateOfBirth,
            CreatedAt = DateTime.UtcNow
        };

        participant.PasswordHash =
            _participantHasher.HashPassword(participant, request.Password);

        _db.Participants.Add(participant);
        await _db.SaveChangesAsync();

        return Created("/api/auth/register", new
        {
            participant.ParticipantID,
            participant.FirstName,
            participant.LastName,
            participant.Email,
            Role = "Participant"
        });
    }

   

    private bool appIsDevelopment()
    {
        return HttpContext.RequestServices
            .GetRequiredService<IWebHostEnvironment>()
            .IsDevelopment();
    }

    [HttpPost("login")]
    public async Task<IActionResult> Login(LoginRequest request)
    {
        var email = request.Email.Trim().ToLowerInvariant();

        var participant = await _db.Participants
            .FirstOrDefaultAsync(p => p.Email.ToLower() == email);

        if (participant != null &&
            !string.IsNullOrWhiteSpace(participant.PasswordHash))
        {
            var result = _participantHasher.VerifyHashedPassword(
                participant,
                participant.PasswordHash,
                request.Password);

            if (result != PasswordVerificationResult.Failed)
            {
                return Ok(CreateToken(
                    participant.ParticipantID,
                    participant.Email,
                    "Participant"));
            }
        }

        var organiser = await _db.Organisers
            .FirstOrDefaultAsync(o => o.Email.ToLower() == email);

        if (organiser != null)
        {
            var result = _organiserHasher.VerifyHashedPassword(
                organiser,
                organiser.PasswordHash,
                request.Password);

            if (result != PasswordVerificationResult.Failed)
            {
                return Ok(CreateToken(
                    organiser.OrganiserID,
                    organiser.Email,
                    "Organiser"));
            }
        }

        return Unauthorized(new
        {
            message = "Invalid email or password."
        });
    }

    private AuthResponse CreateToken(int userId, string email, string role)
    {
        var key = _configuration["Jwt:Key"]
            ?? throw new InvalidOperationException("JWT Key is missing.");

        var claims = new[]
        {
            new Claim(ClaimTypes.NameIdentifier, userId.ToString()),
            new Claim(ClaimTypes.Email, email),
            new Claim(ClaimTypes.Role, role)
        };

        var signingKey = new SymmetricSecurityKey(
            Encoding.UTF8.GetBytes(key));

        var credentials = new SigningCredentials(
            signingKey,
            SecurityAlgorithms.HmacSha256);

        var token = new JwtSecurityToken(
            issuer: _configuration["Jwt:Issuer"],
            audience: _configuration["Jwt:Audience"],
            claims: claims,
            expires: DateTime.UtcNow.AddMinutes(
                _configuration.GetValue<int>("Jwt:ExpiryMinutes", 60)),
            signingCredentials: credentials);

        return new AuthResponse
        {
            Token = new JwtSecurityTokenHandler().WriteToken(token),
            UserId = userId,
            Email = email,
            Role = role
        };
    }
}
