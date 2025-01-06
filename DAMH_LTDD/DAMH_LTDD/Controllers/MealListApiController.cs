using DAMH_LTDD.DTOs;
using DAMH_LTDD.Helpers;
using DAMH_LTDD.Models;
using DAMH_LTDD.Repositories;
using Microsoft.AspNetCore.Mvc;

namespace DAMH_LTDD.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class MealListApiController : ControllerBase
    {
        private readonly IMealListRepository _mealListRepository;

        public MealListApiController(IMealListRepository mealListRepository)
        {
            _mealListRepository = mealListRepository;
        }

        [HttpGet]
        public async Task<IActionResult> GetMealList()
        {
            try
            {
                var mealLists = await _mealListRepository.GetMealListAsync();
                var mealListDtos = mealLists.ToDtoList();
                return Ok(mealListDtos);
            }
            catch (Exception)
            {
                return StatusCode(500, "Lỗi máy chủ nội bộ");
            }
        }

        [HttpGet("{id}")]
        public async Task<IActionResult> GetMealListById(int id)
        {
            try
            {
                var mealList = await _mealListRepository.GetMealListByIdAsync(id);
                if (mealList == null)
                    return NotFound();

                var mealListDto = mealList.ToDto();
                return Ok(mealListDto);
            }
            catch (Exception)
            {
                return StatusCode(500, "Lỗi máy chủ nội bộ");
            }
        }

        [HttpPost]
        public async Task<IActionResult> AddMealList([FromBody] CreateUpdateMealListDto mealListDto)
        {
            try
            {
                var mealList = mealListDto.ToEntity();
                await _mealListRepository.AddMealListAsync(mealList);

                var createdMealListDto = mealList.ToDto();
                return CreatedAtAction(nameof(GetMealListById), new { id = mealList.Id }, createdMealListDto);
            }
            catch (Exception)
            {
                return StatusCode(500, "Lỗi máy chủ nội bộ");
            }
        }

        [HttpPut("{id}")]
        public async Task<IActionResult> UpdateMealList(int id, [FromBody] CreateUpdateMealListDto mealListDto)
        {
            try
            {
                var existingMealList = await _mealListRepository.GetMealListByIdAsync(id);
                if (existingMealList == null)
                    return NotFound();

                existingMealList.Name = mealListDto.Name;
                existingMealList.Description = mealListDto.Description;
                existingMealList.Meal_Time = mealListDto.MealTime;
                existingMealList.UserId = mealListDto.UserId;

                await _mealListRepository.UpdateMealListAsync(existingMealList);

                return NoContent();
            }
            catch (Exception)
            {
                return StatusCode(500, "Lỗi máy chủ nội bộ");
            }
        }

        [HttpDelete("{id}")]
        public async Task<IActionResult> DeleteMealList(int id)
        {
            try
            {
                await _mealListRepository.DeleteMealListAsync(id);
                return NoContent();
            }
            catch (Exception)
            {
                return StatusCode(500, "Lỗi máy chủ nội bộ");
            }
        }
    }
}
