using SeriesApp.Domain.DTOs;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SeriesApp.BLL.Interfaces
{
    public interface IAuthService
    {
        Task<bool> Login(UserDto dto);
        Task<bool> Register(RegisterDto DTO);
    }
}
