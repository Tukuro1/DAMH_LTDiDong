using System.Reflection.Emit;
using Microsoft.AspNetCore.Identity.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore;

namespace DAMH_LTDD.Models
{
    public class ApplicationDbContext : IdentityDbContext<User>
    {
        public ApplicationDbContext(DbContextOptions<ApplicationDbContext> options) : base(options) { }
        public DbSet<MealList> MealLists { get; set; }
        public DbSet<ExerciseList> ExerciseLists { get; set; }
        public DbSet<Food> Foods { get; set; }
        public DbSet<Exercise> Exercises { get; set; }
        public DbSet<CategoryFood> CategoryFoods { get; set; }
        public DbSet<CategoryExercise> CategoryExercises { get; set; }
        public DbSet<MealListFood> MealListFoods { get; set; }
        public DbSet<ExerciseListExercise> ExerciseListExercises { get; set; }

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            base.OnModelCreating(modelBuilder);

            // Sử dụng schema mặc định cho Identity
            modelBuilder.HasDefaultSchema("identity");

            // Cấu hình User
            modelBuilder.Entity<User>();

            // cấu hình User với MealList
            modelBuilder.Entity<User>()
                .HasMany(u => u.MealLists)
                .WithOne(ml => ml.User)
                .HasForeignKey(ml => ml.UserId)
                .OnDelete(DeleteBehavior.Cascade);
            // cấu hình User với ExerciseList
            modelBuilder.Entity<User>()
                .HasMany(u => u.ExerciseLists)
                .WithOne(el => el.User)
                .HasForeignKey(el => el.UserId)
                .OnDelete(DeleteBehavior.Cascade);
            // cấu hình Food với CategoryFood
            modelBuilder.Entity<CategoryFood>()
                .HasMany(cf => cf.Foods)
                .WithOne(f => f.CategoryFoods)
                .HasForeignKey(f => f.CategoryFoodId)
                .OnDelete(DeleteBehavior.Cascade);
            // cấu hình Exercise với CategoryExercise
            modelBuilder.Entity<CategoryExercise>()
                .HasMany(ce => ce.Exercises)
                .WithOne(e => e.CategoryExercises)
                .HasForeignKey(ce => ce.CategoryExerciseId)
                .OnDelete(DeleteBehavior.Cascade);
            // cấu hình MealList với Food thông qua MealListFood
            modelBuilder.Entity<MealListFood>()
                .HasKey(mf => new {mf.FoodId, mf.MealListId});
            modelBuilder.Entity<MealListFood>()
                .HasOne(mf => mf.Foods)
                .WithMany(f => f.MealListFoods)
                .HasForeignKey(mf => mf.FoodId)
                .OnDelete(DeleteBehavior.Cascade);
            modelBuilder.Entity<MealListFood>()
                .HasOne(mf => mf.MealLists)
                .WithMany(m => m.MealListFoods)
                .HasForeignKey(mf => mf.MealListId)
                .OnDelete(DeleteBehavior.Cascade);
            // cấu hình ExerciseList với Exercise thông qua ExerciseListExercise
            modelBuilder.Entity<ExerciseListExercise>()
                .HasKey(ee => new { ee.ExerciseId, ee.ExerciseListId });
            modelBuilder.Entity<ExerciseListExercise>()
                .HasOne(ee => ee.Exercises)
                .WithMany(e => e.ExerciseListExercises)
                .HasForeignKey(ee => ee.ExerciseId)
                .OnDelete(DeleteBehavior.Cascade);
            modelBuilder.Entity<ExerciseListExercise>()
                .HasOne(ee => ee.ExerciseLists)
                .WithMany(el => el.ExerciseListExercises)
                .HasForeignKey(ee => ee.ExerciseListId)
                .OnDelete(DeleteBehavior.Cascade);
        }
    }
}
