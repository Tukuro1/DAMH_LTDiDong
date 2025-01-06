using System.ComponentModel.DataAnnotations;

namespace DAMH_LTDD.Models
{
    public class CategoryFood
    {
        [Key]
        public int Id { get; set; }
        public string? Target { get; set; }
        public ICollection<Food> Foods { get; set; }
    }
}
