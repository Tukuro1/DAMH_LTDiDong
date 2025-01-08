using DAMH_LTDD.Models;
using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using System.Text;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;
using Microsoft.IdentityModel.Tokens;

namespace DAMH_LTDD.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class AuthenticateController : ControllerBase
    {
        private readonly UserManager<User> _userManager;
        private readonly RoleManager<IdentityRole> _roleManager;
        private readonly IConfiguration _configuration;

        public AuthenticateController(
            UserManager<User> userManager,
            RoleManager<IdentityRole> roleManager,
            IConfiguration configuration)
        {
            _userManager = userManager;
            _roleManager = roleManager;
            _configuration = configuration;
        }

        [HttpPost("register")] // Định nghĩa endpoint /api/authenticate/register
        public async Task<IActionResult> Register([FromBody] RegistrationModel model)
        {
            if (!ModelState.IsValid) return BadRequest(ModelState); // Kiểm tra dữ liệu gửi lên có hợp lệ không

            var userExists = await _userManager.FindByNameAsync(model.Username); // Tìm người dùng dựa trên Username
            if (userExists != null)
                return StatusCode(StatusCodes.Status400BadRequest, new { Status = false, Message = "User already exists" }); // Trả về lỗi nếu user đã tồn tại

            // Tạo người dùng mới với Username và Email
            var user = new User
            {
                UserName = model.Username,
                Email = model.Email,
                PhoneNumber = model.PhoneNumber,
            };

            // Tạo người dùng với mật khẩu
            var result = await _userManager.CreateAsync(user, model.Password);
            if (!result.Succeeded) // Kiểm tra nếu việc tạo không thành công
                return StatusCode(StatusCodes.Status500InternalServerError, new { Status = false, Message = "User creation failed" });

            // Nếu có role được chỉ định trong model, kiểm tra role đã tồn tại chưa
            if (!string.IsNullOrEmpty(model.Role))
            {
                if (!await _roleManager.RoleExistsAsync(model.Role)) // Tạo role nếu chưa tồn tại
                {
                    await _roleManager.CreateAsync(new IdentityRole(model.Role));
                }
                await _userManager.AddToRoleAsync(user, model.Role); // Gán role cho user
            }

            return Ok(new { Status = true, Message = "User created successfully" }); // Trả về trạng thái thành công
        }


        [HttpPost("login")] // Định nghĩa endpoint /api/authenticate/login
        public async Task<IActionResult> Login([FromBody] LoginModel model)
        {
            if (!ModelState.IsValid) return BadRequest(ModelState); // Kiểm tra dữ liệu gửi lên

            // Tìm người dùng theo Username
            var user = await _userManager.FindByNameAsync(model.Username);
            if (user == null || !await _userManager.CheckPasswordAsync(user, model.Password))
                return Unauthorized(new { Status = false, Message = "Invalid username or password" }); // Trả về lỗi nếu thông tin không chính xác

            // Lấy danh sách các role của user
            var userRoles = await _userManager.GetRolesAsync(user);

            // Tạo danh sách claims cho JWT token
            var authClaims = new List<Claim>
                {
                    new Claim(ClaimTypes.Name, user.UserName), // Claim tên người dùng
                    new Claim(JwtRegisteredClaimNames.Jti, Guid.NewGuid().ToString()) // Claim ID token (unique)
                };

            // Thêm các claims về role
            foreach (var userRole in userRoles)
            {
                authClaims.Add(new Claim(ClaimTypes.Role, userRole)); // Mỗi role là một claim
            }

            // Sinh token từ danh sách claims
            var token = GenerateToken(authClaims);
            return Ok(new { Status = true, Message = "Logged in successfully", Token = token }); // Trả về token cho client
        }



        private string GenerateToken(IEnumerable<Claim> claims)
        {
            // Lấy các thông tin cấu hình JWT từ appsettings.json
            var jwtSettings = _configuration.GetSection("JWTKey");
            var authSigningKey = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(jwtSettings["Secret"])); // Khóa mã hóa bí mật

            // Cấu hình token
            var tokenDescriptor = new SecurityTokenDescriptor
            {
                Subject = new ClaimsIdentity(claims), // Thêm danh sách claims vào token
                Expires = DateTime.UtcNow.AddHours(Convert.ToDouble(jwtSettings["TokenExpiryTimeInHour"])), // Thời gian hết hạn
                Issuer = jwtSettings["ValidIssuer"], // Issuer (định danh bên phát hành)
                Audience = jwtSettings["ValidAudience"], // Audience (định danh bên nhận)
                SigningCredentials = new SigningCredentials(authSigningKey, SecurityAlgorithms.HmacSha256) // Thuật toán mã hóa
            };

            // Tạo token bằng JwtSecurityTokenHandler
            var tokenHandler = new JwtSecurityTokenHandler();
            var token = tokenHandler.CreateToken(tokenDescriptor); // Sinh token
            return tokenHandler.WriteToken(token); // Trả về token dưới dạng chuỗi
        }

    }
}
