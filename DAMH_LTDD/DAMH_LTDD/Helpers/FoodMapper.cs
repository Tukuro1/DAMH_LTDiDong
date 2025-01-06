using DAMH_LTDD.DTOs;
using DAMH_LTDD.Models;

namespace DAMH_LTDD.Helpers
{
    public static class FoodMapper
    {
        // Chuyển từ Entity sang DTO
        public static FoodDto ToDto(this Food food)
        {
            return new FoodDto
            {
                Id = food.Id,
                NameFood = food.NameFood,
                DescriptionFood = food.DescriptionFood,
                ImgFood = food.ImgFood,
                FoodAmount = food.FoodAmount,
                Calories = food.Calories,
                Protein = food.Protein,
                Fat = food.Fat,
                Meal = food.Meal,
                CategoryFoodId = food.CategoryFoodId
            };
        }

        // Chuyển từ DTO sang Entity
        public static Food ToEntity(this CreateUpdateFoodDto dto)
        {
            return new Food
            {
                NameFood = dto.NameFood,
                DescriptionFood = dto.DescriptionFood,
                ImgFood = dto.ImgFood,
                FoodAmount = dto.FoodAmount,
                Calories = dto.Calories,
                Protein = dto.Protein,
                Fat = dto.Fat,
                Meal = dto.Meal,
                CategoryFoodId = dto.CategoryFoodId
            };
        }

        // Chuyển danh sách Entity sang danh sách DTO
        public static IEnumerable<FoodDto> ToDtoList(this IEnumerable<Food> foods)
        {
            return foods.Select(f => f.ToDto());
        }
    }
}
