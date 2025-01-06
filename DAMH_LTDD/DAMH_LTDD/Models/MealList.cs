using System.ComponentModel.DataAnnotations;

namespace DAMH_LTDD.Models
{
    public class MealList
    {
        [Key]
        public int Id { get; set; }
        public string? Name { get; set; }
        public string? Description { get; set; }
        public DateTime? Meal_Time { get; set; }

        public string UserId { get; set; }
        public User User { get; set; }

        // Many-to-many relationship with Food through MealListFood
        public ICollection<MealListFood>? MealListFoods { get; set; }
    }
}
