using System.ComponentModel.DataAnnotations;

namespace DAMH_LTDD.Models
{
    public class Food
    {
        [Key]
        public int Id { get; set; }
        public string? NameFood { get; set; }
        public string? DescriptionFood { get; set; } // mô tả
        public string? ImgFood { get; set; }
        public int? FoodAmount { get; set; } // số lượng
        public float? Calories { get; set; } // calo
        public float? Protein { get; set; }
        public float? Fat { get; set; } // chất béo
        public string? Meal { get; set; } // loại món ăn : món khai vị, món chính, món tráng miệng
        public int CategoryFoodId { get; set; }
        public CategoryFood CategoryFoods { get; set; }
        public ICollection<MealListFood>? MealListFoods { get; set; }
    }
}
