using DAMH_LTDD.Models;

namespace DAMH_LTDD.Repositories
{
    public interface IExerciseListExerciseRepository
    {
        Task<IEnumerable<ExerciseListExercise>> GetExerciseListExerciseAsync();
        Task<ExerciseListExercise> GetExerciseListExerciseByIdAsync(int exerciseListId, int exerciseId);
        Task AddExerciseListExerciseAsync(ExerciseListExercise exerciseListExercise);
        Task UpdateExerciseListExerciseAsync(ExerciseListExercise exerciseListExercise);
        Task DeleteExerciseListExerciseAsync(int exerciseListId, int exerciseId);
    }
}
