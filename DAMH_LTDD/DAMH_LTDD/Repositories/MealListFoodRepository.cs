using DAMH_LTDD.Models;
using Microsoft.EntityFrameworkCore;

namespace DAMH_LTDD.Repositories
{
    public class MealListFoodRepository : IMealListFoodRepository
    {
        private readonly ApplicationDbContext _context;

        public MealListFoodRepository(ApplicationDbContext context)
        {
            _context = context;
        }

        // Lấy tất cả MealListFood
        public async Task<IEnumerable<MealListFood>> GetMealListFoodAsync()
        {
            return await _context.MealListFoods.ToListAsync();
        }

        // Lấy MealListFood theo MealListId và FoodId
        public async Task<MealListFood> GetMealListFoodByIdAsync(int mealListId, int foodId)
        {
            return await _context.MealListFoods.FirstOrDefaultAsync(mlf => mlf.MealListId == mealListId && mlf.FoodId == foodId);
        }

        // Thêm MealListFood mới
        public async Task AddMealListFoodAsync(MealListFood mealListFood)
        {
            _context.MealListFoods.Add(mealListFood);
            await _context.SaveChangesAsync();
        }

        // Cập nhật MealListFood
        public async Task UpdateMealListFoodAsync(MealListFood mealListFood)
        {
            _context.Entry(mealListFood).State = EntityState.Modified;
            await _context.SaveChangesAsync();
        }

        // Xóa MealListFood theo MealListId và FoodId
        public async Task DeleteMealListFoodAsync(int mealListId, int foodId)
        {
            var mealListFood = await _context.MealListFoods.FirstOrDefaultAsync(mlf => mlf.MealListId == mealListId && mlf.FoodId == foodId);
            if (mealListFood != null)
            {
                _context.MealListFoods.Remove(mealListFood);
                await _context.SaveChangesAsync();
            }
        }
    }
}
