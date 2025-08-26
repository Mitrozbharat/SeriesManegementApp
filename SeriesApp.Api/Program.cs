using Microsoft.EntityFrameworkCore;
using SeriesApp.BLL.Interfaces;
using SeriesApp.BLL.Services;
using SeriesApp.DAL;
using SeriesApp.DAL.Interfaces;
using SeriesApp.DAL.Repository;

var builder = WebApplication.CreateBuilder(args);

// Add services to the container.

builder.Services.AddControllers();
// Learn more about configuring Swagger/OpenAPI at https://aka.ms/aspnetcore/swashbuckle
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();
builder.Services.AddDbContext<SeriesDbContext>(options =>
    options.UseSqlServer(builder.Configuration.GetConnectionString("DefaultConnection")));

builder.Services.AddScoped<ISeriesServices, SeriesService>();
builder.Services.AddScoped<IAuthService, AuthService>();

builder.Services.AddScoped<ISeriesRepo, SeriesRepository>();
builder.Services.AddScoped<IAuthRepo, AuthRepository>();



builder.Services.AddCors(options =>
{
    options.AddPolicy("AllowAll",
        policy => policy.AllowAnyOrigin().AllowAnyMethod().AllowAnyHeader());
});

var app = builder.Build();

// Configure the HTTP request pipeline.
if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

app.UseHttpsRedirection();

app.UseAuthorization();

app.MapControllers();

app.UseCors("AllowAll");

app.Run();
