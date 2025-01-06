using DAMH_LTDD.Models;

namespace DAMH_LTDD.Repositories
{
    public interface IExerciseRepository
    {
        Task<IEnumerable<Exercise>> GetExerciseAsync();
        Task<Exercise> GetExerciseByIdAsync(int id);
        Task AddExerciseAsync(Exercise exercise);
        Task UpdateExerciseAsync(Exercise exercise);
        Task DeleteExerciseAsync(int id);
    }
}
