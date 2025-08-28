using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SeriesApp.Domain.Entities
{
        public class tbl_Series
        {
             [Key]
        [DatabaseGenerated(DatabaseGeneratedOption.Identity)]
        public int SeriesId { get; set; }              
            [Required, MaxLength(250)]
            public string SeriesName { get; set; }

            [Required, MaxLength(50)]
            public string SeriesType { get; set; }           // e.g. International, Domestic

            [Required, MaxLength(50)]
            public string SeriesStatus { get; set; }         // Scheduled, Completed, Live, Abandon

            [Required, MaxLength(50)]
            public string MatchStatus { get; set; }          // Scheduled, Completed, Live, Abandon

            [MaxLength(50)]
            public string MatchFormat { get; set; }          // ODI, TEST, T20, T10

            [MaxLength(100)]
            public string SeriesMatchType { get; set; }      // ODI, TEST, T20I, LIST A, etc.

            [Required, MaxLength(20)]
            public string Gender { get; set; }               // Mens, Womens, Other

            [Required, MaxLength(4)]
            public string Year { get; set; }                 // 4 chars

            [MaxLength(100)]
            public string TrophyType { get; set; }

            public DateTime SeriesStartDate { get; set; }
            public DateTime SeriesEndDate { get; set; }

            public bool IsActive { get; set; } = true;              // true => Yes, false => No

            [MaxLength(500)]
            public string Description { get; set; }
        }
    
}
