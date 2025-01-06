namespace DAMH_LTDD.DTOs
{
    public class MealListDto
    {
        public int Id { get; set; }
        public string? Name { get; set; }
        public string? Description { get; set; }
        public DateTime? MealTime { get; set; }
        public string UserId { get; set; }
    }
}
