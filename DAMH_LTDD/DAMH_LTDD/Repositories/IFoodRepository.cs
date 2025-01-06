using DAMH_LTDD.Models;

namespace DAMH_LTDD.Repositories
{
    public interface IFoodRepository
    {
        Task<IEnumerable<Food>> GetFoodAsync();
        Task<Food> GetFoodByIdAsync(int id);
        Task AddFoodAsync(Food Foods);
        Task UpdateFoodAsync(Food Foods);
        Task DeleteFoodAsync(int id);
    }
}
