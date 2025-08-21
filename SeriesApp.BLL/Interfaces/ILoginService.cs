using SeriesApp.Domain.DTOs;
using SeriesApp.Domain.Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SeriesApp.BLL.Interfaces
{
    public interface ILoginService
    {
 
        Task<bool> Login(UserDto user);
    }
}
