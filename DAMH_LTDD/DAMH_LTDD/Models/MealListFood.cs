using System.ComponentModel.DataAnnotations;
using System.Reflection.Emit;
using Microsoft.EntityFrameworkCore;

namespace DAMH_LTDD.Models
{
    public class MealListFood
    {
/*        [Key]
        public int Id { get; set; }*/
        public int MealListId { get; set; }
        public int FoodId { get; set; }
        public MealList MealLists { get; set; }
        public Food Foods { get; set; }
    }
}
