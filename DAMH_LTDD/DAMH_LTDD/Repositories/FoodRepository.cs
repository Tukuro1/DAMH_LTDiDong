using DAMH_LTDD.Models;
using Microsoft.EntityFrameworkCore;

namespace DAMH_LTDD.Repositories
{
    public class FoodRepository : IFoodRepository
    {
        private readonly ApplicationDbContext _context;
        public FoodRepository(ApplicationDbContext context)
        {
            _context = context;
        }
        public async Task<IEnumerable<Food>> GetFoodAsync()
        {
            return await _context.Foods.ToListAsync();
        }
        public async Task<Food> GetFoodByIdAsync(int id)
        {
            return await _context.Foods.FindAsync(id);
        }
        public async Task AddFoodAsync(Food Foods)
        {
            _context.Foods.Add(Foods);
            await _context.SaveChangesAsync();
        }
        public async Task UpdateFoodAsync(Food Foods)
        {
            _context.Entry(Foods).State = EntityState.Modified;
            await _context.SaveChangesAsync();
        }
        public async Task DeleteFoodAsync(int id)
        {
            var Foods = await _context.Foods.FindAsync(id);
            if (Foods != null)
            {
                _context.Foods.Remove(Foods);
                await _context.SaveChangesAsync();
            }
        }
    }
}
