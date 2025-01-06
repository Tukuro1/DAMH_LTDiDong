using System.ComponentModel.DataAnnotations;

namespace DAMH_LTDD.DTOs
{
    public class CreateUpdateExerciseDto
    {
        [Required]
        public string? Name { get; set; }
        public string? Description { get; set; }
        public string? Img { get; set; }
        public string? Instruct { get; set; }
        [Required]
        public TimeOnly TimeOnly { get; set; }
        public int? SlThucHien { get; set; }
        public int? Reps { get; set; }
        [Required]
        public int CategoryExerciseId { get; set; }
    }
}
