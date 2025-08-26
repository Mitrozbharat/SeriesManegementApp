using Microsoft.EntityFrameworkCore;
using SeriesApp.Domain.Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Reflection.Emit;
using System.Text;
using System.Threading.Tasks;

namespace SeriesApp.DAL
{
    public class SeriesDbContext : DbContext
    {
        public SeriesDbContext(DbContextOptions<SeriesDbContext> options) : base(options) { }

        public DbSet<tbl_Series> tbl_Series { get; set; }
        public DbSet<ErrorLog> ErrorLogs { get; set; } // optional logging table
        public DbSet<Users> Users { get; set; }

        
    }
}
