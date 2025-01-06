using System.ComponentModel.DataAnnotations;

namespace DAMH_LTDD.DTOs
{
    public class CreateUpdateExerciseListDto
    {
        [Required]
        public string? Name { get; set; }
        public DateTime? ExerciseTime { get; set; }
        [Required]
        public string UserId { get; set; }
    }
}
