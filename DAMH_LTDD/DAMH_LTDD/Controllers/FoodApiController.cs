using DAMH_LTDD.DTOs;
using DAMH_LTDD.Helpers;
using DAMH_LTDD.Models;
using DAMH_LTDD.Repositories;
using Microsoft.AspNetCore.Mvc;

namespace DAMH_LTDD.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class FoodApiController : ControllerBase
    {
        private readonly IFoodRepository _foodRepository;

        public FoodApiController(IFoodRepository foodRepository)
        {
            _foodRepository = foodRepository;
        }

        [HttpGet]
        public async Task<IActionResult> GetFoods()
        {
            try
            {
                var foods = await _foodRepository.GetFoodAsync();
                var foodDtos = foods.ToDtoList();
                return Ok(foodDtos);
            }
            catch (Exception)
            {
                return StatusCode(500, "Lỗi máy chủ nội bộ");
            }
        }

        [HttpGet("{id}")]
        public async Task<IActionResult> GetFoodById(int id)
        {
            try
            {
                var food = await _foodRepository.GetFoodByIdAsync(id);
                if (food == null)
                    return NotFound();

                var foodDto = food.ToDto();
                return Ok(foodDto);
            }
            catch (Exception)
            {
                return StatusCode(500, "Lỗi máy chủ nội bộ");
            }
        }

        [HttpPost]
        public async Task<IActionResult> AddFood([FromBody] CreateUpdateFoodDto foodDto)
        {
            try
            {
                var food = foodDto.ToEntity();
                await _foodRepository.AddFoodAsync(food);

                var createdFoodDto = food.ToDto();
                return CreatedAtAction(nameof(GetFoodById), new { id = food.Id }, createdFoodDto);
            }
            catch (Exception)
            {
                return StatusCode(500, "Lỗi máy chủ nội bộ");
            }
        }

        [HttpPut("{id}")]
        public async Task<IActionResult> UpdateFood(int id, [FromBody] CreateUpdateFoodDto foodDto)
        {
            try
            {
                var existingFood = await _foodRepository.GetFoodByIdAsync(id);
                if (existingFood == null)
                    return NotFound();

                existingFood.NameFood = foodDto.NameFood;
                existingFood.DescriptionFood = foodDto.DescriptionFood;
                existingFood.ImgFood = foodDto.ImgFood;
                existingFood.FoodAmount = foodDto.FoodAmount;
                existingFood.Calories = foodDto.Calories;
                existingFood.Protein = foodDto.Protein;
                existingFood.Fat = foodDto.Fat;
                existingFood.Meal = foodDto.Meal;
                existingFood.CategoryFoodId = foodDto.CategoryFoodId;

                await _foodRepository.UpdateFoodAsync(existingFood);

                return NoContent();
            }
            catch (Exception)
            {
                return StatusCode(500, "Lỗi máy chủ nội bộ");
            }
        }

        [HttpDelete("{id}")]
        public async Task<IActionResult> DeleteFood(int id)
        {
            try
            {
                await _foodRepository.DeleteFoodAsync(id);
                return NoContent();
            }
            catch (Exception)
            {
                return StatusCode(500, "Lỗi máy chủ nội bộ");
            }
        }
    }
}
