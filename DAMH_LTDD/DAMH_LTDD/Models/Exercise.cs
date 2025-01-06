using System.ComponentModel.DataAnnotations;

namespace DAMH_LTDD.Models
{
    public class Exercise
    {
        [Key]
        public int Id { get; set; }
        public string? Name { get; set; }
        public string? Description { get; set; } // mô tả
        public string? Img { get; set; }
        public string? instruct { get; set; } // hướng dẫn
        public TimeOnly TimeOnly { get; set; } // thời gian thực hiện
        public int? SlThucHien { get; set; } // số lượng thực hiện động tác
        public int? Reps { get; set; } // Số rep thực hiện vd: 1 rep là 10 lần nâng tạ
        public int CategoryExerciseId { get; set; }
        public CategoryExercise? CategoryExercises { get; set; }
        public ICollection<ExerciseListExercise>? ExerciseListExercises { get; set; }
    }
}
