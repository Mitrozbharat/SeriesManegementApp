using SeriesApp.Domain.Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SeriesApp.DAL.Interfaces
{
    public interface ILoginRepo
    {
       public Task<User> Login(User user);
    }
}
