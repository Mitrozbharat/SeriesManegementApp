using SeriesApp.Domain.Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SeriesApp.DAL.Interfaces
{
    public interface ISeriesRepo
    {
        Task<IEnumerable<tbl_Series>> GetAllSeries();
        Task<int> AddSeriesAsync(tbl_Series series);
        Task<bool> UpdateSeriesAsync(tbl_Series series);
        Task<IEnumerable<tbl_Series>> SearchSeriesAsync(int? seriesId, string seriesType, string seriesName, DateTime? startFrom, DateTime? endTo, string sortBy);

        Task<IEnumerable<tbl_Series>> SearchByAsync(int? seriesId, string? seriesType, string? seriesName, DateTime? startFrom, DateTime? endTo, string? sortBy);
        Task<bool> DeleteAsync(int id);

        List<SeriesReport> GetSeriesReport(int[] years);
    }
}
