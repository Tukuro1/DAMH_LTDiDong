
using System.Text;
using DAMH_LTDD.Models;
using DAMH_LTDD.Repositories;
using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore;
using Microsoft.IdentityModel.Tokens;

var builder = WebApplication.CreateBuilder(args);

//Cấu hình: Dùng SQL Server làm hệ quản trị csdl cho ứng dụng
builder.Services.AddDbContext<ApplicationDbContext>(options => options.UseSqlServer(builder.Configuration.GetConnectionString("DefaultConnection")));

// Register identity
builder.Services.AddIdentity<User, IdentityRole>()
    .AddEntityFrameworkStores<ApplicationDbContext>()
    .AddDefaultTokenProviders();


builder.Services.AddControllers();
builder.Services.AddScoped<IMealListRepository, MealListRepository>();
builder.Services.AddScoped<IExerciseListRepository, ExerciseListRepository>();
builder.Services.AddScoped<IExerciseRepository, ExerciseRepository>();
builder.Services.AddScoped<IFoodRepository, FoodRepository>();
// Learn more about configuring Swagger/OpenAPI at https://aka.ms/aspnetcore/swashbuckle
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

// Configure CORS: Cross-Origin Resource Sharing, được dịch là “Chia sẻ tài nguyên giữa các nguồn gốc khác nhau
builder.Services.AddCors(options =>
{
    options.AddPolicy(name: "MyAllowOrigins", policy =>
    {
        //Thay bằng địa chỉ localhost khi khởi chạy bên frontend (VSCode)
        policy.WithOrigins("http://127.0.0.1:5500", "http://localhost:5500")
        .AllowAnyHeader()
        .AllowAnyMethod();
    });
});

//Configure JWT Authentication
var jwtSettings = builder.Configuration.GetSection("JWTKey");
var key = Encoding.UTF8.GetBytes(jwtSettings["Secret"]);

builder.Services.AddAuthentication(options =>
{
    options.DefaultAuthenticateScheme = "Bearer";
    options.DefaultChallengeScheme = "Bearer";
})
.AddJwtBearer("Bearer", options =>
{
    options.TokenValidationParameters = new TokenValidationParameters
    {
        ValidateIssuer = true,
        ValidateAudience = true,
        ValidateLifetime = true,
        ValidateIssuerSigningKey = true,
        ValidIssuer = jwtSettings["ValidIssuer"],
        ValidAudience = jwtSettings["ValidAudience"],
        IssuerSigningKey = new SymmetricSecurityKey(key)
    };
});

builder.Services.AddAuthorization();

var app = builder.Build();

//Tạo ra các Role trong ứng dụng để sau này thực hiện phân quyền
using (var scope = app.Services.CreateScope())
{
    var roleManager = scope.ServiceProvider.GetRequiredService<RoleManager<IdentityRole>>();
    var roles = new[] { "Admin", "User" };
    foreach (var role in roles)
    {
        if (!await roleManager.RoleExistsAsync(role))
        {
            await roleManager.CreateAsync(new IdentityRole(role));
        }
    }
}

if (!app.Environment.IsDevelopment())
{
    app.UseExceptionHandler("/error"); // Custom error handling endpoint
    app.UseHsts(); // Enforce HTTPS in production
}
else
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

app.UseHttpsRedirection();
// Áp dụng CORS cho các yêu cầu đến API
app.UseCors("MyAllowOrigins");

app.UseAuthentication();

app.UseAuthorization();

app.MapControllers();

app.Run();
