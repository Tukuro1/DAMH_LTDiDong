using System.ComponentModel.DataAnnotations;

namespace DAMH_LTDD.Models
{
    public class ExerciseListExercise
    {
/*        [Key]
        public int Id { get; set; }*/
        public int ExerciseListId { get; set; }
        public int ExerciseId { get; set; }
        public ExerciseList ExerciseLists { get; set; }
        public Exercise Exercises { get; set; }
    }
}
