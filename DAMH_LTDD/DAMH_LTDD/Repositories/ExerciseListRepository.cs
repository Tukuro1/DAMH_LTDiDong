using DAMH_LTDD.Models;
using Microsoft.EntityFrameworkCore;

namespace DAMH_LTDD.Repositories
{
    public class ExerciseListRepository : IExerciseListRepository
    {
        private readonly ApplicationDbContext _context;
        public ExerciseListRepository(ApplicationDbContext context)
        {
            _context = context;
        }
        public async Task<IEnumerable<ExerciseList>> GetExerciseListAsync()
        {
            return await _context.ExerciseLists.ToListAsync();
        }
        public async Task<ExerciseList> GetExerciseListByIdAsync(int id)
        {
            return await _context.ExerciseLists.FindAsync(id);
        }
        public async Task AddExerciseListAsync(ExerciseList exerciseList)
        {
            _context.ExerciseLists.Add(exerciseList);
            await _context.SaveChangesAsync();
        }
        public async Task UpdateExerciseListAsync(ExerciseList exerciseList)
        {
            _context.Entry(exerciseList).State = EntityState.Modified;
            await _context.SaveChangesAsync();
        }
        public async Task DeleteExerciseListAsync(int id)
        {
            var exerciseList = await _context.ExerciseLists.FindAsync(id);
            if (exerciseList != null)
            {
                _context.ExerciseLists.Remove(exerciseList);
                await _context.SaveChangesAsync();
            }
        }
    }
}
