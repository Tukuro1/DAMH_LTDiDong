using DAMH_LTDD.DTOs;
using DAMH_LTDD.Helpers;
using DAMH_LTDD.Models;
using DAMH_LTDD.Repositories;
using Microsoft.AspNetCore.Mvc;

namespace DAMH_LTDD.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class ExerciseApiController : ControllerBase
    {
        private readonly IExerciseRepository _exerciseRepository;

        public ExerciseApiController(IExerciseRepository exerciseRepository)
        {
            _exerciseRepository = exerciseRepository;
        }

        [HttpGet]
        public async Task<IActionResult> GetExercises()
        {
            try
            {
                var exercises = await _exerciseRepository.GetExerciseAsync();
                var exerciseDtos = exercises.ToDtoList();
                return Ok(exerciseDtos);
            }
            catch (Exception)
            {
                return StatusCode(500, "Lỗi máy chủ nội bộ");
            }
        }

        [HttpGet("{id}")]
        public async Task<IActionResult> GetExerciseById(int id)
        {
            try
            {
                var exercise = await _exerciseRepository.GetExerciseByIdAsync(id);
                if (exercise == null)
                    return NotFound();

                var exerciseDto = exercise.ToDto();
                return Ok(exerciseDto);
            }
            catch (Exception)
            {
                return StatusCode(500, "Lỗi máy chủ nội bộ");
            }
        }

        [HttpPost]
        public async Task<IActionResult> AddExercise([FromBody] CreateUpdateExerciseDto exerciseDto)
        {
            try
            {
                var exercise = exerciseDto.ToEntity();
                await _exerciseRepository.AddExerciseAsync(exercise);

                var createdExerciseDto = exercise.ToDto();
                return CreatedAtAction(nameof(GetExerciseById), new { id = exercise.Id }, createdExerciseDto);
            }
            catch (Exception)
            {
                return StatusCode(500, "Lỗi máy chủ nội bộ");
            }
        }

        [HttpPut("{id}")]
        public async Task<IActionResult> UpdateExercise(int id, [FromBody] CreateUpdateExerciseDto exerciseDto)
        {
            try
            {
                var existingExercise = await _exerciseRepository.GetExerciseByIdAsync(id);
                if (existingExercise == null)
                    return NotFound();

                existingExercise.Name = exerciseDto.Name;
                existingExercise.Description = exerciseDto.Description;
                existingExercise.Img = exerciseDto.Img;
                existingExercise.instruct = exerciseDto.Instruct;
                existingExercise.TimeOnly = exerciseDto.TimeOnly;
                existingExercise.SlThucHien = exerciseDto.SlThucHien;
                existingExercise.Reps = exerciseDto.Reps;
                existingExercise.CategoryExerciseId = exerciseDto.CategoryExerciseId;

                await _exerciseRepository.UpdateExerciseAsync(existingExercise);

                return NoContent();
            }
            catch (Exception)
            {
                return StatusCode(500, "Lỗi máy chủ nội bộ");
            }
        }

        [HttpDelete("{id}")]
        public async Task<IActionResult> DeleteExercise(int id)
        {
            try
            {
                await _exerciseRepository.DeleteExerciseAsync(id);
                return NoContent();
            }
            catch (Exception)
            {
                return StatusCode(500, "Lỗi máy chủ nội bộ");
            }
        }
    }
}
