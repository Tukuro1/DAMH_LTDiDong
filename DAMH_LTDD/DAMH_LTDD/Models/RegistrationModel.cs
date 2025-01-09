using System.ComponentModel.DataAnnotations;

namespace DAMH_LTDD.Models
{
    public class RegistrationModel
    {
        [Required]
        public string Username { get; set; } = string.Empty;
        [Required, EmailAddress]
        public string Email { get; set; } = string.Empty;
        [Required, MinLength(6)]
        public string Password { get; set; } = string.Empty;
        public string PhoneNumber { get; set; } = string.Empty;
        public DateOnly Date_of_birth { get; set; }
        public bool? Sex { get; set; } // giới tính 0:nam, 1:nữ
        public string? Role { get; set; } // Optional - assign a role if needed

    }
}
