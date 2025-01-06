using DAMH_LTDD.DTOs;
using DAMH_LTDD.Models;

namespace DAMH_LTDD.Helpers
{
    public static class ExerciseMapper
    {
        // Chuyển từ Entity sang DTO
        public static ExerciseDto ToDto(this Exercise exercise)
        {
            return new ExerciseDto
            {
                Id = exercise.Id,
                Name = exercise.Name,
                Description = exercise.Description,
                Img = exercise.Img,
                Instruct = exercise.instruct,
                TimeOnly = exercise.TimeOnly,
                SlThucHien = exercise.SlThucHien,
                Reps = exercise.Reps,
                CategoryExerciseId = exercise.CategoryExerciseId
            };
        }

        // Chuyển từ DTO sang Entity
        public static Exercise ToEntity(this CreateUpdateExerciseDto dto)
        {
            return new Exercise
            {
                Name = dto.Name,
                Description = dto.Description,
                Img = dto.Img,
                instruct = dto.Instruct,
                TimeOnly = dto.TimeOnly,
                SlThucHien = dto.SlThucHien,
                Reps = dto.Reps,
                CategoryExerciseId = dto.CategoryExerciseId
            };
        }

        // Chuyển danh sách Entity sang danh sách DTO
        public static IEnumerable<ExerciseDto> ToDtoList(this IEnumerable<Exercise> exercises)
        {
            return exercises.Select(e => e.ToDto());
        }
    }
}
