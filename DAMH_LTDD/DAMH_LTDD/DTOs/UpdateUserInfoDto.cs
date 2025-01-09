namespace DAMH_LTDD.DTOs
{
    public class UpdateUserInfoDto
    {
        public string UserId { get; set; } // ID của người dùng
        public string UserName { get; set; }
        public string Email { get; set; }
        public int Height { get; set; } // Chiều cao
        public float Weight { get; set; } // Cân nặng
    }
}
