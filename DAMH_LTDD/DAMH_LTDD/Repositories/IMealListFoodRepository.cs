using DAMH_LTDD.Models;

namespace DAMH_LTDD.Repositories
{
    public interface IMealListFoodRepository
    {
        // Lấy tất cả các MealListFood
        Task<IEnumerable<MealListFood>> GetMealListFoodAsync();

        // Lấy MealListFood theo MealListId và FoodId
        Task<MealListFood> GetMealListFoodByIdAsync(int mealListId, int foodId);

        // Thêm MealListFood mới
        Task AddMealListFoodAsync(MealListFood mealListFood);

        // Cập nhật MealListFood
        Task UpdateMealListFoodAsync(MealListFood mealListFood);

        // Xóa MealListFood theo MealListId và FoodId
        Task DeleteMealListFoodAsync(int mealListId, int foodId);
    }
}
