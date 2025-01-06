using Microsoft.AspNetCore.Identity;

namespace DAMH_LTDD.Models
{
    public class User: IdentityUser
    {
        public int? Height { get; set; }
        public float? Weight { get; set; }
        public DateOnly? Date_of_birth { get; set; }
        public bool? Sex { get; set; } // giới tính 0:nam, 1:nữ
        public bool? Demand { get; set; } //nhu cầu của user 0: giảm cân, 1: tăng cân
        public bool? Recommend { get; set; } // gợi ý từ hệ thống -1=null=cân nặng và chiêu cao hợp lý, 0=false=giảm cân, 1=true=tăng cân 
        public ICollection<MealList> MealLists { get; set; }
        public ICollection<ExerciseList> ExerciseLists { get; set; }
    }
}
