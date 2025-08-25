using Microsoft.Data.SqlClient;
using SeriesApp.DAL.Interfaces;
using SeriesApp.Domain.Entities;
using System;
using Microsoft.Extensions.Configuration;
namespace SeriesApp.DAL.Repository
{
    public class LoginRepository : ILoginRepo
    {
        private readonly SeriesDbContext _context;
        private readonly string _connectionString;
        public LoginRepository(SeriesDbContext seriesDb, IConfiguration configration)
        {
            this._connectionString = configration.GetConnectionString("DefaultConnection");
            this._context = seriesDb;
        }
        public async Task<User> Login(User user)
        {

            try
            {
                var list = new List<User>
            {
                new User { Id = 1, Username = "bharat", Password = "Pass@123" }
            };

                var matchedUser = list.FirstOrDefault(x =>
                    x.Username == user.Username && x.Password == user.Password);

                return await Task.FromResult(matchedUser);
            }
            catch (Exception ex)
            {
                await LogErrorAsync(ex, nameof(Login));
                throw;
            }
        
          
        }

        private async Task LogErrorAsync(Exception ex, string methodName)
        {
            try
            {
                using var conn = new SqlConnection(_connectionString);
                using var cmd = new SqlCommand(
                    "INSERT INTO ErrorLogs (OccurredOn, Message, StackTrace, AdditionalInfo) VALUES (@occurredOn, @message, @stackTrace, @additionalInfo)", conn);

                cmd.Parameters.AddWithValue("@occurredOn", DateTime.UtcNow);
                cmd.Parameters.AddWithValue("@message", ex.Message);
                cmd.Parameters.AddWithValue("@stackTrace", ex.StackTrace ?? "");
                cmd.Parameters.AddWithValue("@additionalInfo", methodName);

                await conn.OpenAsync();
                await cmd.ExecuteNonQueryAsync();
            }
            catch
            {
                Console.WriteLine("Error");
            }
        }

    }
}
