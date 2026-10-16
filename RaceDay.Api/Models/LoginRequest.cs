
using System.ComponentModel.DataAnnotations;

namespace RaceDay.Api.Models;

public class LoginRequest
{
    [Required, EmailAddress, MaxLength(150)]
    public string Email { get; set; } = string.Empty;

    [Required]
    public string Password { get; set; } = string.Empty;
}
