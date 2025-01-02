﻿using System.ComponentModel.DataAnnotations;

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
        public string? Role { get; set; } // Optional - assign a role if needed

    }
}