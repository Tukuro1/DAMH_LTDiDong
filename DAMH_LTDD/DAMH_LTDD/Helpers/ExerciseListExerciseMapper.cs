using DAMH_LTDD.DTOs;
using DAMH_LTDD.Helpers;
using DAMH_LTDD.Models;

namespace DAMH_LTDD.Mappers
{
    public static class ExerciseListExerciseMapper
    {
        // Chuyển từ Entity sang DTO
        public static ExerciseListExerciseDto ToDto(this ExerciseListExercise entity)
        {
            return new ExerciseListExerciseDto
            {
                ExerciseListId = entity.ExerciseListId,
                ExerciseId = entity.ExerciseId,
                ExerciseList = entity.ExerciseLists?.ToDto(),  // Chuyển đối tượng ExerciseList thành ExerciseListDto
                exerciseDto = entity.Exercises?.ToDto()        // Chuyển đối tượng Exercise thành ExerciseDto
            };
        }

        // Chuyển từ DTO sang Entity
        public static ExerciseListExercise ToEntity(this CreateUpdateExerciseListExerciseDto dto)
        {
            return new ExerciseListExercise
            {
                ExerciseListId = dto.ExerciseListId,
                ExerciseId = dto.ExerciseId
            };
        }

        // Chuyển danh sách Entity sang danh sách DTO
        public static IEnumerable<ExerciseListExerciseDto> ToDtoList(this IEnumerable<ExerciseListExercise> exerciseListExercises)
        {
            return exerciseListExercises.Select(m => m.ToDto());
        }
    }
}
