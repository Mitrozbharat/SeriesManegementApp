using SeriesApp.BLL.Interfaces;
using SeriesApp.DAL.Interfaces;
using SeriesApp.Domain.DTOs;
using SeriesApp.Domain.Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SeriesApp.BLL.Services
{
    public class AuthService : IAuthService
    {
        private readonly IAuthRepo _authRepo;
       

        public AuthService(IAuthRepo authService)
        {
            _authRepo = authService;
        }

        Task<bool> IAuthService.Login(UserDto dto)
        {
            var user = new Users
            {
                Username = dto.Username,
                Password = dto.Password,
                
            };
            return _authRepo.Login(user);
        }

        Task<bool> IAuthService.Register(RegisterDto dto)
        {

          
            var user = new Users
            { 
                Username = dto.Username,
                Email = dto.Email,
                Password = dto.Password ,   
                Name = dto.Name,   
           
            };

            return _authRepo.Register(user); ;
        }
    }
}
