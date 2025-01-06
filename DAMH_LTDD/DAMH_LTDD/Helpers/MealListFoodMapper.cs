using DAMH_LTDD.DTOs;
using DAMH_LTDD.Models;

namespace DAMH_LTDD.Helpers
{
    public static class MealListFoodMapper
    {
        // Chuyển từ Entity sang DTO
        public static MealListFoodDto ToDto(this MealListFood mealListFood)
        {
            return new MealListFoodDto
            {
                MealListId = mealListFood.MealListId,
                FoodId = mealListFood.FoodId,
                MealList = mealListFood.MealLists?.ToDto(), // Giả sử MealListDto cũng có phương thức ToDto()
                Food = mealListFood.Foods?.ToDto() // Giả sử FoodDto cũng có phương thức ToDto()
            };
        }

        // Chuyển từ DTO sang Entity
        public static MealListFood ToEntity(this CreateUpdateMealListFoodDto dto)
        {
            return new MealListFood
            {
                MealListId = dto.MealListId,
                FoodId = dto.FoodId
            };
        }

        // Chuyển danh sách Entity sang danh sách DTO
        public static IEnumerable<MealListFoodDto> ToDtoList(this IEnumerable<MealListFood> mealListFoods)
        {
            return mealListFoods.Select(m => m.ToDto());
        }
    }
}
