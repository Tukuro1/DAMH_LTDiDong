using DAMH_LTDD.DTOs;
using DAMH_LTDD.Helpers;
using DAMH_LTDD.Models;
using DAMH_LTDD.Repositories;
using Microsoft.AspNetCore.Mvc;

namespace DAMH_LTDD.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class MealListFoodApiController : ControllerBase
    {
        private readonly IMealListFoodRepository _mealListFoodRepository;

        public MealListFoodApiController(IMealListFoodRepository mealListFoodRepository)
        {
            _mealListFoodRepository = mealListFoodRepository;
        }

        [HttpGet]
        public async Task<IActionResult> GetMealListFoods()
        {
            try
            {
                var mealListFoods = await _mealListFoodRepository.GetMealListFoodAsync();
                var mealListFoodDtos = mealListFoods.ToDtoList();
                return Ok(mealListFoodDtos);
            }
            catch (Exception)
            {
                return StatusCode(500, "Lỗi máy chủ nội bộ");
            }
        }

        [HttpGet("{mealListId}/{foodId}")]
        public async Task<IActionResult> GetMealListFoodByIds(int mealListId, int foodId)
        {
            try
            {
                var mealListFood = await _mealListFoodRepository.GetMealListFoodByIdAsync(mealListId, foodId);
                if (mealListFood == null)
                    return NotFound();

                var mealListFoodDto = mealListFood.ToDto();
                return Ok(mealListFoodDto);
            }
            catch (Exception)
            {
                return StatusCode(500, "Lỗi máy chủ nội bộ");
            }
        }

        [HttpPost]
        public async Task<IActionResult> AddMealListFood([FromBody] CreateUpdateMealListFoodDto mealListFoodDto)
        {
            try
            {
                var mealListFood = mealListFoodDto.ToEntity();
                await _mealListFoodRepository.AddMealListFoodAsync(mealListFood);

                var createdMealListFoodDto = mealListFood.ToDto();
                return CreatedAtAction(nameof(GetMealListFoodByIds), new { mealListId = mealListFood.MealListId, foodId = mealListFood.FoodId }, createdMealListFoodDto);
            }
            catch (Exception)
            {
                return StatusCode(500, "Lỗi máy chủ nội bộ");
            }
        }

        [HttpPut("{mealListId}/{foodId}")]
        public async Task<IActionResult> UpdateMealListFood(int mealListId, int foodId, [FromBody] CreateUpdateMealListFoodDto mealListFoodDto)
        {
            try
            {
                var existingMealListFood = await _mealListFoodRepository.GetMealListFoodByIdAsync(mealListId, foodId);
                if (existingMealListFood == null)
                    return NotFound();

                existingMealListFood.MealListId = mealListFoodDto.MealListId;
                existingMealListFood.FoodId = mealListFoodDto.FoodId;

                await _mealListFoodRepository.UpdateMealListFoodAsync(existingMealListFood);

                return NoContent();
            }
            catch (Exception)
            {
                return StatusCode(500, "Lỗi máy chủ nội bộ");
            }
        }

        [HttpDelete("{mealListId}/{foodId}")]
        public async Task<IActionResult> DeleteMealListFood(int mealListId, int foodId)
        {
            try
            {
                await _mealListFoodRepository.DeleteMealListFoodAsync(mealListId, foodId);
                return NoContent();
            }
            catch (Exception)
            {
                return StatusCode(500, "Lỗi máy chủ nội bộ");
            }
        }
    }
}
