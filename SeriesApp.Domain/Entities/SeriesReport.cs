using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SeriesApp.Domain.Entities
{
   public  class SeriesReport
    {
        public string MatchFormat { get; set; }
        public int Year { get; set; }
        public int Men { get; set; }
        public int Women { get; set; }
        public int Other { get; set; }
    }
}
