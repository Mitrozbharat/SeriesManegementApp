using Microsoft.AspNetCore.Mvc;
using Microsoft.Data.SqlClient;
using SeriesApp.BLL.Interfaces;
using SeriesApp.BLL.Services;
using SeriesApp.Domain.Entities;
using System;
using System.Threading.Tasks;

namespace SeriesApp.API.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class SeriesController : ControllerBase
    {
        private readonly ISeriesServices _service;
        public SeriesController(ISeriesServices service) => _service = service;



        [HttpGet("GetSeries")]
        public async Task<IActionResult> GetAllSeries()
        {

            var series = await _service.GetAllSeries();
            return Ok(series);
        }

        [HttpPost,Route("Create")]
        public async Task<IActionResult> Create([FromBody] tbl_Series dto)
        {
            var created = await _service.CreateSeriesAsync(dto);
            return CreatedAtAction(nameof(Search), new { id = created }, dto);
        }

        
        [HttpPut("Update/{id}")]
        public async Task<IActionResult> Update(int id, [FromBody] tbl_Series dto)
        {
            dto.SeriesId = id;

            if (dto.SeriesStartDate > dto.SeriesEndDate)
                return BadRequest("Start Date cannot be greater than End Date.");


            if (dto.SeriesStartDate < new DateTime(2000, 1, 1))
                return BadRequest("Start Date must be after 01-Jan-2000.");

            if (dto.SeriesEndDate > DateTime.UtcNow.AddYears(5))
                return BadRequest("End Date cannot be more than 5 years in the future.");

            if (id != dto.SeriesId) return BadRequest("Id mismatch");
            var ok = await _service.UpdateSeriesAsync(dto);
            if (!ok) return NotFound();
            return NoContent();
        }

        [HttpGet("Search")]
        public async Task<IActionResult> Search([FromQuery] int? seriesId, [FromQuery] string? seriesType, [FromQuery] string? seriesName,
                                             [FromQuery] DateTime? startFrom, [FromQuery] DateTime? endTo, [FromQuery] string? sortBy )
        {
            var list = await _service.SearchByAsync(seriesId, seriesType, seriesName, startFrom, endTo, sortBy);

            return Ok(list);
        }

       
        [HttpDelete("{id}", Name = "Delete")]
        public async Task<IActionResult> DeleteSeries(int id)
        {
            try
            {
                var success = await _service.DeleteAsync(id);
                if (success)
                {
                    return Ok(new { message = "Series  inactive successfully." });
                }

                return NotFound(new { message = $"Series with ID {id} not found." });
            }
            catch (SqlException ex) when (ex.Message.Contains("Cannot delete series"))
            {
                return BadRequest(new { message = ex.Message });
            }
            catch (Exception ex)
            {
                return StatusCode(500, new { message = "An error occurred while marking the series as inactive.", error = ex.Message });
            }
        }


        [HttpGet("GetSeriesReport")]
        public IActionResult GetSeriesReport([FromQuery] int[] years)
        {
            if (years == null || years.Length == 0)
                return BadRequest("Please select at least one year.");

            var data = _service.GetSeriesReport(years);
            return Ok(data);
        }

    }
}
