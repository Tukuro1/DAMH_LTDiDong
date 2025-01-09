using DAMH_LTDD.Models;
using Microsoft.EntityFrameworkCore;

namespace DAMH_LTDD.Repositories
{
    public class ExerciseListExerciseRepository : IExerciseListExerciseRepository
    {
        private readonly ApplicationDbContext _context;

        public ExerciseListExerciseRepository(ApplicationDbContext context)
        {
            _context = context;
        }
        // Lấy tất cả ExerciseListExercise
        public async Task<IEnumerable<ExerciseListExercise>> GetExerciseListExerciseAsync()
        {
            return await _context.ExerciseListExercises.ToListAsync();
        }
        // Lấy ExerciseListExercise theo ExerciseListId và ExerciseId
        public async Task<ExerciseListExercise> GetExerciseListExerciseByIdAsync(int exerciseListId, int exerciseId)
        {
            return await _context.ExerciseListExercises.FirstOrDefaultAsync(ele => ele.ExerciseListId == exerciseId && ele.ExerciseId == exerciseId);
        }
        // Thêm ExerciseListExercise mới
        public async Task AddExerciseListExerciseAsync(ExerciseListExercise exerciseListExercise)
        {
            _context.ExerciseListExercises.Add(exerciseListExercise);
            await _context.SaveChangesAsync();
        }
        // Cập nhật ExerciseListExercise
        public async Task UpdateExerciseListExerciseAsync(ExerciseListExercise exerciseListExercise)
        {
            _context.Entry(exerciseListExercise).State = EntityState.Modified;
            await _context.SaveChangesAsync();
        }
        // Xóa ExerciseListExercise theo ExerciseListId và ExerciseId
        public async Task DeleteExerciseListExerciseAsync(int exerciseListId, int exerciseId)
        {
            var exerciseListExercise = await _context.ExerciseListExercises
                .FirstOrDefaultAsync(ele => ele.ExerciseListId == exerciseListId && ele.ExerciseId == exerciseId);
            if (exerciseListExercise != null)
            {
                _context.ExerciseListExercises.Remove(exerciseListExercise);
                await _context.SaveChangesAsync();
            }
        }
    }
}
