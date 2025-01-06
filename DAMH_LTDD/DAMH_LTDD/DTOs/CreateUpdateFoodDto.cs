using System.ComponentModel.DataAnnotations;

namespace DAMH_LTDD.DTOs
{
    public class CreateUpdateFoodDto
    {
        [Required]
        public string? NameFood { get; set; }
        public string? DescriptionFood { get; set; }
        public string? ImgFood { get; set; }
        public int? FoodAmount { get; set; }
        public float? Calories { get; set; }
        public float? Protein { get; set; }
        public float? Fat { get; set; }
        public string? Meal { get; set; }
        [Required]
        public int CategoryFoodId { get; set; }
    }
}
