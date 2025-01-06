using DAMH_LTDD.DTOs;
using DAMH_LTDD.Models;

namespace DAMH_LTDD.Helpers
{
    public static class MealListMapper
    {
        // Chuyển từ Entity sang DTO
        public static MealListDto ToDto(this MealList mealList)
        {
            return new MealListDto
            {
                Id = mealList.Id,
                Name = mealList.Name,
                Description = mealList.Description,
                MealTime = mealList.Meal_Time,
                UserId = mealList.UserId
            };
        }

        // Chuyển từ DTO sang Entity
        public static MealList ToEntity(this CreateUpdateMealListDto dto)
        {
            return new MealList
            {
                Name = dto.Name,
                Description = dto.Description,
                Meal_Time = dto.MealTime,
                UserId = dto.UserId
            };
        }

        // Chuyển danh sách Entity sang danh sách DTO
        public static IEnumerable<MealListDto> ToDtoList(this IEnumerable<MealList> mealLists)
        {
            return mealLists.Select(m => m.ToDto());
        }
    }
}
