using System.ComponentModel.DataAnnotations;

namespace DAMH_LTDD.Models
{
    public class ExerciseList
    {
        [Key]
        public int Id { get; set; }
        public string? Name { get; set; }
        public DateTime? Exercise_Time { get; set; }

        public string UserId { get; set; }
        public User User { get; set; }

        // Many-to-many relationship with Food through MealListFood
        public ICollection<ExerciseListExercise>? ExerciseListExercises { get; set; }
    }
}
