using SeriesApp.DAL.Interfaces;
using SeriesApp.Domain.Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SeriesApp.DAL.Repository
{
    public class LoginRepository : ILoginRepo
    {
        private readonly SeriesDbContext _context;
        public LoginRepository(SeriesDbContext seriesDb)
        {

            _context = seriesDb;
        }
        public Task<User> Login(User user)
        {
            var list = new List<User>
            {
                new User { Id = 1, Username = "bharat", Password = "Pass@123" }
            };

            var matchedUser = list.FirstOrDefault(x =>
                x.Username == user.Username && x.Password == user.Password);

            return Task.FromResult(matchedUser);
        }


    }
}
