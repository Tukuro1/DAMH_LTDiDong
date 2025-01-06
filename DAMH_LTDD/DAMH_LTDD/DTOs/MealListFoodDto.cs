namespace DAMH_LTDD.DTOs
{
    public class MealListFoodDto
    {
        public int MealListId { get; set; }
        public int FoodId { get; set; }
        public MealListDto MealList { get; set; }
        public FoodDto Food { get; set; }
    }
}
