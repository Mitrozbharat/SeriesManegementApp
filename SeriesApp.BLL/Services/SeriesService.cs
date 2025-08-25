using SeriesApp.BLL.Interfaces;
using SeriesApp.DAL.Interfaces;
using SeriesApp.DAL.Repository;
using SeriesApp.Domain.Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SeriesApp.BLL.Services
{
    public class SeriesService: ISeriesServices
    {
        private readonly ISeriesRepo _repo;
        public SeriesService(ISeriesRepo repo)  
        {
            _repo = repo;
        }


        public Task<IEnumerable<tbl_Series>> GetAllSeries()
        {
            return _repo.GetAllSeries();
        }

        public async Task<int> CreateSeriesAsync(tbl_Series series)
        {
            // basic validation
            if (string.IsNullOrWhiteSpace(series.SeriesName))
                throw new ArgumentException("SeriesName is required");
            if (string.IsNullOrWhiteSpace(series.Gender))
                throw new ArgumentException("Gender is required");

            series.SeriesId = await _repo.AddSeriesAsync(series);
            return series.SeriesId;
        }

        public Task<bool> UpdateSeriesAsync(tbl_Series series)
        {
            // Add validations if needed
            return _repo.UpdateSeriesAsync(series);
        }

 
        public Task<IEnumerable<tbl_Series>> SearchByAsync(int? seriesId, string? seriesType, string? seriesName, DateTime? startFrom, DateTime? endTo, string? sortBy)
        {
            return _repo.SearchByAsync(seriesId, seriesType, seriesName, startFrom, endTo, sortBy);
        }

        public Task<bool> DeleteAsync(int id)
        {
            return _repo.DeleteAsync(id);
        }

        public List<SeriesReport> GetSeriesReport(int[] years)
        {
            return _repo.GetSeriesReport(years);
        }
        
    }
}