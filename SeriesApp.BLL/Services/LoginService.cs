using SeriesApp.BLL.Interfaces;
using SeriesApp.Domain.Entities;
using SeriesApp.DAL.Interfaces;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using SeriesApp.Domain.DTOs;

namespace SeriesApp.BLL.Services
{
    public class LoginService : ILoginService
    {
        private readonly ILoginRepo _login;
        public LoginService(ILoginRepo login)
        {
            _login = login;
        }
     

        public async Task<bool> Login(UserDto dto)
        {
            var user = new User
            {
                Username = dto.Username,
                Password = dto.Password
            };

            var user1 = await _login.Login(user);
            return user1 != null;
        }
    }
}
