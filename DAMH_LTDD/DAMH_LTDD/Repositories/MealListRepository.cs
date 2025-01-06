using DAMH_LTDD.Models;
using Microsoft.EntityFrameworkCore;

namespace DAMH_LTDD.Repositories
{
    public class MealListRepository : IMealListRepository
    {
        private readonly ApplicationDbContext _context;
        public MealListRepository(ApplicationDbContext context)
        {
            _context = context;
        }
        public async Task<IEnumerable<MealList>> GetMealListAsync()
        {
            return await _context.MealLists.ToListAsync();
        }
        public async Task<MealList> GetMealListByIdAsync(int id)
        {
            return await _context.MealLists.FindAsync(id);
        }
        public async Task AddMealListAsync(MealList mealList)
        {
            _context.MealLists.Add(mealList);
            await _context.SaveChangesAsync();
        }
        public async Task UpdateMealListAsync(MealList mealList)
        {
            _context.Entry(mealList).State = EntityState.Modified;
            await _context.SaveChangesAsync();
        }
        public async Task DeleteMealListAsync(int id)
        {
            var mealList = await _context.MealLists.FindAsync(id);
            if (mealList != null)
            {
                _context.MealLists.Remove(mealList);
                await _context.SaveChangesAsync();
            }
        }
    }
}
