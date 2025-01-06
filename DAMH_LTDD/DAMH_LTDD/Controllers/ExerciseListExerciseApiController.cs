using DAMH_LTDD.DTOs;
using DAMH_LTDD.Helpers;
using DAMH_LTDD.Mappers;
using DAMH_LTDD.Models;
using DAMH_LTDD.Repositories;
using Microsoft.AspNetCore.Mvc;

namespace DAMH_LTDD.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class ExerciseListExerciseApiController : ControllerBase
    {
        private readonly IExerciseListExerciseRepository _exerciseListExerciseRepository;

        public ExerciseListExerciseApiController(IExerciseListExerciseRepository exerciseListExerciseRepository)
        {
            _exerciseListExerciseRepository = exerciseListExerciseRepository;
        }

        [HttpGet]
        public async Task<IActionResult> GetExerciseListExercises()
        {
            try
            {
                var exerciseListExercises = await _exerciseListExerciseRepository.GetExerciseListExerciseAsync();
                var exerciseListExerciseDtos = exerciseListExercises.ToDtoList();
                return Ok(exerciseListExerciseDtos);
            }
            catch (Exception)
            {
                return StatusCode(500, "Lỗi máy chủ nội bộ");
            }
        }

        [HttpGet("{exerciseListId}/{exerciseId}")]
        public async Task<IActionResult> GetExerciseListExerciseByIds(int exerciseListId, int exerciseId)
        {
            try
            {
                var exerciseListExercise = await _exerciseListExerciseRepository.GetExerciseListExerciseByIdAsync(exerciseListId, exerciseId);
                if (exerciseListExercise == null)
                    return NotFound();

                var exerciseListExerciseDto = exerciseListExercise.ToDto();
                return Ok(exerciseListExerciseDto);
            }
            catch (Exception)
            {
                return StatusCode(500, "Lỗi máy chủ nội bộ");
            }
        }

        [HttpPost]
        public async Task<IActionResult> AddExerciseListExercise([FromBody] CreateUpdateExerciseListExerciseDto exerciseListExerciseDto)
        {
            try
            {
                var exerciseListExercise = exerciseListExerciseDto.ToEntity();
                await _exerciseListExerciseRepository.AddExerciseListExerciseAsync(exerciseListExercise);

                var createdExerciseListExerciseDto = exerciseListExercise.ToDto();
                return CreatedAtAction(nameof(GetExerciseListExerciseByIds), new { exerciseListId = exerciseListExercise.ExerciseListId, exerciseId = exerciseListExercise.ExerciseId }, createdExerciseListExerciseDto);
            }
            catch (Exception)
            {
                return StatusCode(500, "Lỗi máy chủ nội bộ");
            }
        }

        [HttpPut("{exerciseListId}/{exerciseId}")]
        public async Task<IActionResult> UpdateExerciseListExercise(int exerciseListId, int exerciseId, [FromBody] CreateUpdateExerciseListExerciseDto exerciseListExerciseDto)
        {
            try
            {
                var existingExerciseListExercise = await _exerciseListExerciseRepository.GetExerciseListExerciseByIdAsync(exerciseListId, exerciseId);
                if (existingExerciseListExercise == null)
                    return NotFound();

                existingExerciseListExercise.ExerciseListId = exerciseListExerciseDto.ExerciseListId;
                existingExerciseListExercise.ExerciseId = exerciseListExerciseDto.ExerciseId;

                await _exerciseListExerciseRepository.UpdateExerciseListExerciseAsync(existingExerciseListExercise);

                return NoContent();
            }
            catch (Exception)
            {
                return StatusCode(500, "Lỗi máy chủ nội bộ");
            }
        }

        [HttpDelete("{exerciseListId}/{exerciseId}")]
        public async Task<IActionResult> DeleteExerciseListExercise(int exerciseListId, int exerciseId)
        {
            try
            {
                await _exerciseListExerciseRepository.DeleteExerciseListExerciseAsync(exerciseListId, exerciseId);
                return NoContent();
            }
            catch (Exception)
            {
                return StatusCode(500, "Lỗi máy chủ nội bộ");
            }
        }
    }
}
