
using Microsoft.AspNetCore.Authentication;
using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.Mvc.Testing;
using Microsoft.AspNetCore.TestHost;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Infrastructure;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.DependencyInjection.Extensions;
using Microsoft.Extensions.Logging;
using Microsoft.Extensions.Options;
using RaceDay.Api.Data;
using System.Net;
using System.Net.Http.Json;
using System.Security.Claims;
using System.Text.Encodings.Web;

namespace RaceDay.Tests;

public class UnitTest1
{
    [Fact]
    public async Task GetEvents_ReturnsOk()
    {
        await using var factory = new RaceDayApiFactory();
        using var client = factory.CreateClient();

        var response = await client.GetAsync("/api/events");

        Assert.Equal(HttpStatusCode.OK, response.StatusCode);
    }

    [Fact]
    public async Task GetEvent_WithNonExistingId_ReturnsNotFound()
    {
        await using var factory = new RaceDayApiFactory();
        using var client = factory.CreateClient();

        var response = await client.GetAsync("/api/events/999999");

        Assert.Equal(HttpStatusCode.NotFound, response.StatusCode);
    }

    [Fact]
    public async Task CreateEvent_WithoutAuthentication_ReturnsUnauthorized()
    {
        await using var factory = new RaceDayApiFactory();
        using var client = factory.CreateClient();

        var response = await client.PostAsJsonAsync("/api/events", new
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

        Assert.Equal(HttpStatusCode.Unauthorized, response.StatusCode);
    }

    [Fact]
    public async Task CreateEvent_AsParticipant_ReturnsForbidden()
    {
        await using var factory = new RaceDayApiFactory();
        using var client = factory.CreateClient();

        client.DefaultRequestHeaders.Add("X-Test-Role", "Participant");

        var response = await client.PostAsJsonAsync("/api/events", new
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

public class RaceDayApiFactory : WebApplicationFactory<Program>
{
    protected override void ConfigureWebHost(IWebHostBuilder builder)
    {
        builder.ConfigureAppConfiguration((context, configuration) =>
        {
            configuration.AddInMemoryCollection(
                new Dictionary<string, string?>
                {
                    ["Jwt:Key"] =
                        "RaceDay_Test_Key_Only_For_Automated_Tests_123456789!",
                    ["Jwt:Issuer"] = "RaceDay.Api",
                    ["Jwt:Audience"] = "RaceDay.Client"
                });
        });

        builder.ConfigureTestServices(services =>
        {
            services.RemoveAll<RaceDayDbContext>();
            services.RemoveAll<DbContextOptions<RaceDayDbContext>>();
            services.RemoveAll<
                IDbContextOptionsConfiguration<RaceDayDbContext>>();

            services.AddDbContext<RaceDayDbContext>(options =>
                options.UseInMemoryDatabase(
                    "RaceDayTests_" + Guid.NewGuid()));

            services.AddAuthentication(options =>
            {
                options.DefaultAuthenticateScheme = "Test";
                options.DefaultChallengeScheme = "Test";
                options.DefaultScheme = "Test";
            }).AddScheme<AuthenticationSchemeOptions, TestAuthHandler>(
                "Test", options => { });
        });
    }
}

public class TestAuthHandler
    : AuthenticationHandler<AuthenticationSchemeOptions>
{
    public TestAuthHandler(
        IOptionsMonitor<AuthenticationSchemeOptions> options,
        ILoggerFactory logger,
        UrlEncoder encoder)
        : base(options, logger, encoder)
    {
    }

    protected override Task<AuthenticateResult> HandleAuthenticateAsync()
    {
        if (!Request.Headers.TryGetValue("X-Test-Role", out var role))
        {
            return Task.FromResult(AuthenticateResult.NoResult());
        }

        var claims = new[]
        {
            new Claim(ClaimTypes.NameIdentifier, "4"),
            new Claim(ClaimTypes.Role, role.ToString())
        };

        var identity = new ClaimsIdentity(claims, Scheme.Name);
        var principal = new ClaimsPrincipal(identity);
        var ticket = new AuthenticationTicket(principal, Scheme.Name);

        return Task.FromResult(AuthenticateResult.Success(ticket));
    }
}
