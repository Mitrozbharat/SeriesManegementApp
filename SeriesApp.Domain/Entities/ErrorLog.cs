using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SeriesApp.Domain.Entities
{
    public class ErrorLog
    {
        [Key]
        public int ErrorLogId { get; set; }
        public DateTime OccurredOn { get; set; } = DateTime.UtcNow;
        public string Message { get; set; }
        public string StackTrace { get; set; }
        public string AdditionalInfo { get; set; }
    }
}
