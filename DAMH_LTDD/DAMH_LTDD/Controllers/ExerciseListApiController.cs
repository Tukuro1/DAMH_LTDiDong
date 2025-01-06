using DAMH_LTDD.DTOs;
using DAMH_LTDD.Helpers;
using DAMH_LTDD.Models;
using DAMH_LTDD.Repositories;
using Microsoft.AspNetCore.Mvc;

namespace DAMH_LTDD.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class ExerciseListApiController : ControllerBase
    {
        private readonly IExerciseListRepository _exerciseListRepository;

        public ExerciseListApiController(IExerciseListRepository exerciseListRepository)
        {
            _exerciseListRepository = exerciseListRepository;
        }

        [HttpGet]
        public async Task<IActionResult> GetExerciseList()
        {
            try
            {
                var exerciseLists = await _exerciseListRepository.GetExerciseListAsync();
                var exerciseListDtos = exerciseLists.ToDtoList();
                return Ok(exerciseListDtos);
            }
            catch (Exception)
            {
                return StatusCode(500, "Lỗi máy chủ nội bộ");
            }
        }

        [HttpGet("{id}")]
        public async Task<IActionResult> GetExerciseListById(int id)
        {
            try
            {
                var exerciseList = await _exerciseListRepository.GetExerciseListByIdAsync(id);
                if (exerciseList == null)
                    return NotFound();

                var exerciseListDto = exerciseList.ToDto();
                return Ok(exerciseListDto);
            }
            catch (Exception)
            {
                return StatusCode(500, "Lỗi máy chủ nội bộ");
            }
        }

        [HttpPost]
        public async Task<IActionResult> AddExerciseList([FromBody] CreateUpdateExerciseListDto exerciseListDto)
        {
            try
            {
                var exerciseList = exerciseListDto.ToEntity();
                await _exerciseListRepository.AddExerciseListAsync(exerciseList);

                var createdExerciseListDto = exerciseList.ToDto();
                return CreatedAtAction(nameof(GetExerciseListById), new { id = exerciseList.Id }, createdExerciseListDto);
            }
            catch (Exception)
            {
                return StatusCode(500, "Lỗi máy chủ nội bộ");
            }
        }

        [HttpPut("{id}")]
        public async Task<IActionResult> UpdateExerciseList(int id, [FromBody] CreateUpdateExerciseListDto exerciseListDto)
        {
            try
            {
                var existingExerciseList = await _exerciseListRepository.GetExerciseListByIdAsync(id);
                if (existingExerciseList == null)
                    return NotFound();

                existingExerciseList.Name = exerciseListDto.Name;
                existingExerciseList.Exercise_Time = exerciseListDto.ExerciseTime;
                existingExerciseList.UserId = exerciseListDto.UserId;

                await _exerciseListRepository.UpdateExerciseListAsync(existingExerciseList);
                return NoContent();
            }
            catch (Exception)
            {
                return StatusCode(500, "Lỗi máy chủ nội bộ");
            }
        }

        [HttpDelete("{id}")]
        public async Task<IActionResult> DeleteExerciseList(int id)
        {
            try
            {
                await _exerciseListRepository.DeleteExerciseListAsync(id);
                return NoContent();
            }
            catch (Exception)
            {
                return StatusCode(500, "Lỗi máy chủ nội bộ");
            }
        }
    }
}
