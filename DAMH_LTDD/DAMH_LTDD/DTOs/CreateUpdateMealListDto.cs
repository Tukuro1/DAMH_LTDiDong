using System.ComponentModel.DataAnnotations;

namespace DAMH_LTDD.DTOs
{
    public class CreateUpdateMealListDto
    {
        [Required]
        public string? Name { get; set; }

        public string? Description { get; set; }

        public DateTime? MealTime { get; set; }

        [Required]
        public string UserId { get; set; }
    }
}
