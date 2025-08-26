using Microsoft.Data.SqlClient;
using Microsoft.EntityFrameworkCore;
using SeriesApp.DAL.Interfaces;
using SeriesApp.Domain.DTOs;
using SeriesApp.Domain.Entities;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;



using Microsoft.Extensions.Configuration;

namespace SeriesApp.DAL.Repository
{
    public class AuthRepository : IAuthRepo
    {
        private readonly string _connectionString;
        private readonly SeriesDbContext _context;

        public AuthRepository(SeriesDbContext context, IConfiguration configration)
        {
            var connStr = configration.GetConnectionString("DefaultConnection");

            if (string.IsNullOrEmpty(connStr))
                throw new InvalidOperationException("Connection string 'DefaultConnection' is missing or null.");
            this._connectionString = connStr;

            this._context = context;
        }
            
        public async Task<bool> Login(Users users)
        {
            try
            {
                var user = await _context.Users.FirstOrDefaultAsync(u => u.Username == users.Username || u.Email== users.Username && u.Password == users.Password);

                if (user == null)
                {
                    return false;
                }

                return true;
            }
            catch (Exception ex)
            {
                await LogErrorAsync(ex, nameof(Login));
                throw;  
            }


        }
        public async Task<bool> Register(Users dto)
        {
            using var conn = new SqlConnection(_connectionString);
            using var cmd = new SqlCommand("Insert into Users (Name,Email,Username,Password) values(@Name,@Email,@Username,@Password)", conn)
            { CommandType = CommandType.Text };

            cmd.Parameters.AddWithValue("@Name", dto.Name);
            cmd.Parameters.AddWithValue("@Email", dto.Email);
            cmd.Parameters.AddWithValue("@Username",dto.Username);
            cmd.Parameters.AddWithValue("@Password",dto.Password);
           
            var outId = new SqlParameter("@Id", SqlDbType.Int)

            { Direction = ParameterDirection.Output };

            cmd.Parameters.Add(outId);

            try
            {
              await conn.OpenAsync();
              var one =   await cmd.ExecuteNonQueryAsync();
                if(one <= 0)
                    return false;
                return true;
            }
            catch (Exception ex)
            {
                await LogErrorAsync(ex, nameof(Register));
                throw;
            }

            return true;
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
