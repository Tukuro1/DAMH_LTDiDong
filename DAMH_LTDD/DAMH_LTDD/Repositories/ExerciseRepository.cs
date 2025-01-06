using DAMH_LTDD.Models;
using Microsoft.EntityFrameworkCore;

namespace DAMH_LTDD.Repositories
{
    public class ExerciseRepository : IExerciseRepository
    {
        private readonly ApplicationDbContext _context;
        public ExerciseRepository(ApplicationDbContext context)
        {
            _context = context;
        }
        public async Task<IEnumerable<Exercise>> GetExerciseAsync()
        {
            return await _context.Exercises.ToListAsync();
        }
        public async Task<Exercise> GetExerciseByIdAsync(int id)
        {
            return await _context.Exercises.FindAsync(id);
        }
        public async Task AddExerciseAsync(Exercise Exercises)
        {
            _context.Exercises.Add(Exercises);
            await _context.SaveChangesAsync();
        }
        public async Task UpdateExerciseAsync(Exercise Exercises)
        {
            _context.Entry(Exercises).State = EntityState.Modified;
            await _context.SaveChangesAsync();
        }
        public async Task DeleteExerciseAsync(int id)
        {
            var Exercises = await _context.Exercises.FindAsync(id);
            if (Exercises != null)
            {
                _context.Exercises.Remove(Exercises);
                await _context.SaveChangesAsync();
            }
        }
    }
}
