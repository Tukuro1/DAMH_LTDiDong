namespace DAMH_LTDD.DTOs
{
    public class ExerciseDto
    {
        public int Id { get; set; }
        public string? Name { get; set; }
        public string? Description { get; set; }
        public string? Img { get; set; }
        public string? Instruct { get; set; }
        public TimeOnly TimeOnly { get; set; }
        public int? SlThucHien { get; set; }
        public int? Reps { get; set; }
        public int CategoryExerciseId { get; set; }
    }
}
