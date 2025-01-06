using System.ComponentModel.DataAnnotations;

namespace DAMH_LTDD.Models
{
    public class CategoryExercise
    {
        [Key]
        public int Id { get; set; }
        public string? Target { get; set; }
        public string? MuscleGroup { get; set; } // nhóm cơ tác động
        public string? Perform { get; set; } // gym, cadio, ...
        public ICollection<Exercise>? Exercises { get; set; }
    }
}
