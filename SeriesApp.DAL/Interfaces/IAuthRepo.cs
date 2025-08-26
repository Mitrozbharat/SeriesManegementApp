using SeriesApp.Domain.DTOs;
using SeriesApp.Domain.Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SeriesApp.DAL.Interfaces
{
    public interface IAuthRepo
    {
       Task<bool> Login(Users user);
       Task<bool> Register(Users dto);
    }
}
