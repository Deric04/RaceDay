
using Microsoft.AspNetCore.Mvc.Testing;
using System.Net;
using System.Net.Http.Json;
using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using System.Text;
using Microsoft.Extensions.Configuration;
using Microsoft.IdentityModel.Tokens;
using System.Net.Http.Headers;
using Microsoft.Extensions.DependencyInjection;

namespace RaceDay.Tests;

public class UnitTest1
{
    [Fact]
    public async Task GetEvents_ReturnsOk()
    {
        await using var factory = new WebApplicationFactory<Program>();
        using var client = factory.CreateClient();

        var response = await client.GetAsync("/api/events");

        Assert.Equal(HttpStatusCode.OK, response.StatusCode);
    }

    [Fact]
    public async Task GetEvent_WithNonExistingId_ReturnsNotFound()
    {
        await using var factory = new WebApplicationFactory<Program>();
        using var client = factory.CreateClient();

        var response = await client.GetAsync("/api/events/999999");

        Assert.Equal(HttpStatusCode.NotFound, response.StatusCode);
    }

    [Fact]
    public async Task CreateEvent_WithoutToken_ReturnsUnauthorized()
    {
        await using var factory = new WebApplicationFactory<Program>();
        using var client = factory.CreateClient();

        var response = await client.PostAsJsonAsync(
            "/api/events",
            new
            {
                eventID = 0,
                organiserID = 3,
                venueID = 1,
                eventName = "Unauthorized Test",
                eventDescription = "Testing access control",
                eventDate = DateTime.UtcNow.AddDays(30),
                registrationDeadline = DateTime.UtcNow.AddDays(20),
                status = "Open"
            });

        Assert.Equal(
            HttpStatusCode.Unauthorized,
            response.StatusCode);
    }
    [Fact]
    public async Task CreateEvent_AsParticipant_ReturnsForbidden()
    {
        await using var factory = new WebApplicationFactory<Program>();
        using var client = factory.CreateClient();

        var config = factory.Services.GetRequiredService<IConfiguration>();
        var key = config["Jwt:Key"]!;
        var issuer = config["Jwt:Issuer"]!;
        var audience = config["Jwt:Audience"]!;

        var claims = new[]
        {
        new Claim(ClaimTypes.NameIdentifier, "4"),
        new Claim(ClaimTypes.Email, "deric.runner26@example.com"),
        new Claim(ClaimTypes.Role, "Participant")
    };

        var signingKey = new SymmetricSecurityKey(
            Encoding.UTF8.GetBytes(key));

        var credentials = new SigningCredentials(
            signingKey, SecurityAlgorithms.HmacSha256);

        var token = new JwtSecurityToken(
            issuer: issuer,
            audience: audience,
            claims: claims,
            expires: DateTime.UtcNow.AddMinutes(10),
            signingCredentials: credentials);

        client.DefaultRequestHeaders.Authorization =
            new AuthenticationHeaderValue(
                "Bearer",
                new JwtSecurityTokenHandler().WriteToken(token));

        var response = await client.PostAsJsonAsync(
            "/api/events",
            new
            {
                eventID = 0,
                organiserID = 3,
                venueID = 1,
                eventName = "Participant Access Test",
                eventDescription = "Testing Participant permissions",
                eventDate = DateTime.UtcNow.AddDays(30),
                registrationDeadline = DateTime.UtcNow.AddDays(20),
                status = "Open"
            });

        Assert.Equal(HttpStatusCode.Forbidden, response.StatusCode);
    }
}
