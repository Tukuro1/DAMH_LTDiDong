using DAMH_LTDD.DTOs;
using DAMH_LTDD.Models;

namespace DAMH_LTDD.Helpers
{
    public static class ExerciseListMapper
    {
        // Chuyển từ Entity sang DTO
        public static ExerciseListDto ToDto(this ExerciseList exerciseList)
        {
            return new ExerciseListDto
            {
                Id = exerciseList.Id,
                Name = exerciseList.Name,
                ExerciseTime = exerciseList.Exercise_Time,
                UserId = exerciseList.UserId
            };
        }

        // Chuyển từ DTO sang Entity
        public static ExerciseList ToEntity(this CreateUpdateExerciseListDto dto)
        {
            return new ExerciseList
            {
                Name = dto.Name,
                Exercise_Time = dto.ExerciseTime,
                UserId = dto.UserId
            };
        }

        // Chuyển danh sách Entity sang danh sách DTO
        public static IEnumerable<ExerciseListDto> ToDtoList(this IEnumerable<ExerciseList> exerciseLists)
        {
            return exerciseLists.Select(e => e.ToDto());
        }
    }
}
