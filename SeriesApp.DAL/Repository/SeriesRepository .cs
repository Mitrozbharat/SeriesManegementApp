using Microsoft.Data.SqlClient;
using Microsoft.Extensions.Configuration;
using SeriesApp.DAL.Interfaces;
using SeriesApp.Domain.Entities;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SeriesApp.DAL.Repository
{
    public class SeriesRepository : ISeriesRepo
    {
        private readonly string _connectionString;

        public SeriesRepository(IConfiguration configuration)
        {
            // read from appsettings.json via IConfiguration
            _connectionString = configuration.GetConnectionString("DefaultConnection");
        }

        public async Task<int> AddSeriesAsync(tbl_Series s)
        {
            using var conn = new SqlConnection(_connectionString);
            using var cmd = new SqlCommand("dbo.prcTblSeriesInsert", conn) { CommandType = CommandType.StoredProcedure };

            cmd.Parameters.AddWithValue("@SeriesName", s.SeriesName);
            cmd.Parameters.AddWithValue("@SeriesType", s.SeriesType);
            cmd.Parameters.AddWithValue("@SeriesStatus", s.SeriesStatus);
            cmd.Parameters.AddWithValue("@MatchStatus", s.MatchStatus);
            cmd.Parameters.AddWithValue("@MatchFormat", (object?)s.MatchFormat ?? DBNull.Value);
            cmd.Parameters.AddWithValue("@SeriesMatchType", (object?)s.SeriesMatchType ?? DBNull.Value);
            cmd.Parameters.AddWithValue("@Gender", s.Gender);
            cmd.Parameters.AddWithValue("@Year", s.Year);
            cmd.Parameters.AddWithValue("@TrophyType", s.TrophyType);
            cmd.Parameters.AddWithValue("@SeriesStartDate", s.SeriesStartDate);
            cmd.Parameters.AddWithValue("@SeriesEndDate", s.SeriesEndDate);
            cmd.Parameters.AddWithValue("@IsActive", s.IsActive);
            cmd.Parameters.AddWithValue("@Description", (object?)s.Description ?? DBNull.Value);

            var outId = new SqlParameter("@NewSeriesId", SqlDbType.Int) { Direction = ParameterDirection.Output };
            cmd.Parameters.Add(outId);

            await conn.OpenAsync();
            await cmd.ExecuteNonQueryAsync();

            int newId = (outId.Value == DBNull.Value) ? 0 : Convert.ToInt32(outId.Value);
            return (newId);
        }

        public async Task<bool> UpdateSeriesAsync(tbl_Series s)
        {
            using var conn = new SqlConnection(_connectionString);
            using var cmd = new SqlCommand("dbo.prcTblSeriesUpdate", conn)
            {
                CommandType = CommandType.StoredProcedure
            };

            cmd.Parameters.AddWithValue("@SeriesId", s.SeriesId);
            cmd.Parameters.AddWithValue("@SeriesName", s.SeriesName);
            cmd.Parameters.AddWithValue("@SeriesType", s.SeriesType);
            cmd.Parameters.AddWithValue("@SeriesStatus", s.SeriesStatus);
            cmd.Parameters.AddWithValue("@MatchStatus", s.MatchStatus);
            cmd.Parameters.AddWithValue("@MatchFormat", (object?)s.MatchFormat ?? DBNull.Value);
            cmd.Parameters.AddWithValue("@SeriesMatchType", (object?)s.SeriesMatchType ?? DBNull.Value);
            cmd.Parameters.AddWithValue("@Gender", s.Gender);
            cmd.Parameters.AddWithValue("@Year", s.Year);
            cmd.Parameters.AddWithValue("@TrophyType", s.TrophyType);
            cmd.Parameters.AddWithValue("@SeriesStartDate", s.SeriesStartDate);
            cmd.Parameters.AddWithValue("@SeriesEndDate", s.SeriesEndDate);
            cmd.Parameters.AddWithValue("@IsActive", s.IsActive);
            cmd.Parameters.AddWithValue("@Description", (object?)s.Description ?? DBNull.Value);

            // Add OUTPUT parameter
            var rowsAffectedParam = new SqlParameter("@RowsAffected", SqlDbType.Int)
            {
                Direction = ParameterDirection.Output
            };
            cmd.Parameters.Add(rowsAffectedParam);

            await conn.OpenAsync();
            await cmd.ExecuteNonQueryAsync();

            // Read OUTPUT parameter
            int rowsAffected = (int)rowsAffectedParam.Value;
            return rowsAffected > 0;
        }

        public async Task<IEnumerable<tbl_Series>> SearchSeriesAsync(int? seriesId, string seriesType, string seriesName, DateTime? startFrom, DateTime? endTo, string sortBy)
        {
            var list = new List<tbl_Series>();
            using var conn = new SqlConnection(_connectionString);
            using var cmd = new SqlCommand("dbo.prcTblSeriesSearch", conn) { CommandType = CommandType.StoredProcedure };

            cmd.Parameters.AddWithValue("@SeriesId", (object?)seriesId ?? DBNull.Value);
            cmd.Parameters.AddWithValue("@SeriesType", (object?)seriesType ?? DBNull.Value);
            cmd.Parameters.AddWithValue("@SeriesName", (object?)seriesName ?? DBNull.Value);
            cmd.Parameters.AddWithValue("@StartFromDate", (object?)startFrom ?? DBNull.Value);
            cmd.Parameters.AddWithValue("@EndToDate", (object?)endTo ?? DBNull.Value);
            cmd.Parameters.AddWithValue("@SortBy", (object?)sortBy ?? DBNull.Value);

            await conn.OpenAsync();
            using var reader = await cmd.ExecuteReaderAsync();
            while (await reader.ReadAsync())
            {
                list.Add(new tbl_Series
                {
                    SeriesId = reader.GetInt32(reader.GetOrdinal("SeriesId")),
                    SeriesName = reader.GetString(reader.GetOrdinal("SeriesName")),
                    SeriesType = reader.GetString(reader.GetOrdinal("SeriesType")),
                    SeriesStatus = reader.GetString(reader.GetOrdinal("SeriesStatus")),
                    MatchStatus = reader.GetString(reader.GetOrdinal("MatchStatus")),
                    MatchFormat = reader.IsDBNull(reader.GetOrdinal("MatchFormat")) ? null : reader.GetString(reader.GetOrdinal("MatchFormat")),
                    SeriesMatchType = reader.IsDBNull(reader.GetOrdinal("SeriesMatchType")) ? null : reader.GetString(reader.GetOrdinal("SeriesMatchType")),
                    Gender = reader.GetString(reader.GetOrdinal("Gender")),
                    Year = reader.GetString(reader.GetOrdinal("Year")),
                    TrophyType = reader.GetString(reader.GetOrdinal("TrophyType")),
                    SeriesStartDate = reader.GetDateTime(reader.GetOrdinal("SeriesStartDate")),
                    SeriesEndDate = reader.GetDateTime(reader.GetOrdinal("SeriesEndDate")),
                    IsActive = reader.GetBoolean(reader.GetOrdinal("IsActive")),
                    Description = reader.IsDBNull(reader.GetOrdinal("Description")) ? null : reader.GetString(reader.GetOrdinal("Description"))
                });
            }
            return list;
        }

        public async Task<IEnumerable<tbl_Series>> GetAllSeries()
        {
            var seriesList = new List<tbl_Series>();

            using var conn = new SqlConnection(_connectionString);
            using var cmd = new SqlCommand("SELECT * FROM tbl_Series", conn)
            {
                CommandType = CommandType.Text
            };

            await conn.OpenAsync();
            using var reader = await cmd.ExecuteReaderAsync();

            while (await reader.ReadAsync())
            {
                var series = new tbl_Series
                {
                    SeriesId = reader.GetInt32(reader.GetOrdinal("SeriesId")),
                    SeriesName = reader.IsDBNull(reader.GetOrdinal("SeriesName")) ? null : reader.GetString(reader.GetOrdinal("SeriesName")),
                    SeriesType = reader.IsDBNull(reader.GetOrdinal("SeriesType")) ? null : reader.GetString(reader.GetOrdinal("SeriesType")),
                    SeriesStatus = reader.IsDBNull(reader.GetOrdinal("SeriesStatus")) ? null : reader.GetString(reader.GetOrdinal("SeriesStatus")),
                    MatchStatus = reader.IsDBNull(reader.GetOrdinal("MatchStatus")) ? null : reader.GetString(reader.GetOrdinal("MatchStatus")),
                    MatchFormat = reader.IsDBNull(reader.GetOrdinal("MatchFormat")) ? null : reader.GetString(reader.GetOrdinal("MatchFormat")),
                    SeriesMatchType = reader.IsDBNull(reader.GetOrdinal("SeriesMatchType")) ? null : reader.GetString(reader.GetOrdinal("SeriesMatchType")),
                    Gender = reader.IsDBNull(reader.GetOrdinal("Gender")) ? null : reader.GetString(reader.GetOrdinal("Gender")),
                    Year = reader.IsDBNull(reader.GetOrdinal("Year")) ? null : reader.GetString(reader.GetOrdinal("Year")),
                    TrophyType = reader.IsDBNull(reader.GetOrdinal("TrophyType")) ? null : reader.GetString(reader.GetOrdinal("TrophyType")),

                    Description = reader.IsDBNull(reader.GetOrdinal("Description")) ? null : reader.GetString(reader.GetOrdinal("Description"))
                };

                seriesList.Add(series);
            }

            return seriesList;
        }

        public async Task<IEnumerable<tbl_Series>> SearchByAsync(int? seriesId, string? seriesType, string? seriesName, DateTime? startFrom, DateTime? endTo, string? sortBy)
        {

            var list = new List<tbl_Series>();
            using var conn = new SqlConnection(_connectionString);
            using var cmd = new SqlCommand("dbo.prcTblSeriesSearch", conn) { CommandType = CommandType.StoredProcedure };

            cmd.Parameters.AddWithValue("@SeriesId", (object?)seriesId ?? DBNull.Value);
            cmd.Parameters.AddWithValue("@SeriesType", (object?)seriesType ?? DBNull.Value);
            cmd.Parameters.AddWithValue("@SeriesName", (object?)seriesName ?? DBNull.Value);
            cmd.Parameters.AddWithValue("@StartFromDate", (object?)startFrom ?? DBNull.Value);
            cmd.Parameters.AddWithValue("@EndToDate", (object?)endTo ?? DBNull.Value);
            cmd.Parameters.AddWithValue("@SortBy", (object?)sortBy ?? DBNull.Value);

            await conn.OpenAsync();
            using var reader = await cmd.ExecuteReaderAsync();
            while (await reader.ReadAsync())
            {
                list.Add(new tbl_Series
                {
                    SeriesId = reader.GetInt32(reader.GetOrdinal("SeriesId")),
                    SeriesName = reader.GetString(reader.GetOrdinal("SeriesName")),
                    SeriesType = reader.GetString(reader.GetOrdinal("SeriesType")),
                    SeriesStatus = reader.GetString(reader.GetOrdinal("SeriesStatus")),
                    MatchStatus = reader.GetString(reader.GetOrdinal("MatchStatus")),
                    MatchFormat = reader.IsDBNull(reader.GetOrdinal("MatchFormat")) ? null : reader.GetString(reader.GetOrdinal("MatchFormat")),
                    SeriesMatchType = reader.IsDBNull(reader.GetOrdinal("SeriesMatchType")) ? null : reader.GetString(reader.GetOrdinal("SeriesMatchType")),
                    Gender = reader.GetString(reader.GetOrdinal("Gender")),
                    Year = reader.GetString(reader.GetOrdinal("Year")),
                    TrophyType = reader.GetString(reader.GetOrdinal("TrophyType")),
                    SeriesStartDate = reader.GetDateTime(reader.GetOrdinal("SeriesStartDate")),
                    SeriesEndDate = reader.GetDateTime(reader.GetOrdinal("SeriesEndDate")),
                    IsActive = reader.GetBoolean(reader.GetOrdinal("IsActive")),
                    Description = reader.IsDBNull(reader.GetOrdinal("Description")) ? null : reader.GetString(reader.GetOrdinal("Description"))
                });
            }
            return list;

        }

        public async Task<bool> DeleteAsync(int id)
        {
            using var conn = new SqlConnection(_connectionString);
            using var cmd = new SqlCommand("dbo.prcTblSeriesDelete", conn) { CommandType = CommandType.StoredProcedure };
            cmd.Parameters.AddWithValue("@SeriesId", id);

            await conn.OpenAsync();
            using var transaction = conn.BeginTransaction();
            cmd.Transaction = transaction;
            try
            {
                var rowsAffected = await cmd.ExecuteNonQueryAsync();
                await transaction.CommitAsync();
                return rowsAffected > 0;
            }
            catch
            {
                await transaction.RollbackAsync();
                throw;
            }
        }

        public List<SeriesReport> GetSeriesReport(int[] years)
        {
            var result = new List<SeriesReport>();

            using (var conn = new SqlConnection(_connectionString))
            using (var cmd = new SqlCommand("dbo.GetSeriesReportYears1", conn))
            {
                cmd.CommandType = CommandType.StoredProcedure;

                // Convert int array to comma-separated string
                string yearsParam = string.Join(",", years);
                cmd.Parameters.AddWithValue("@Years", yearsParam);

                conn.Open();
                using (var reader = cmd.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        result.Add(new SeriesReport
                        {
                            MatchFormat = reader["MatchFormat"].ToString(),
                            Year = Convert.ToInt32(reader["Year"]),
                            Men = Convert.ToInt32(reader["Men"]),
                            Women = Convert.ToInt32(reader["Women"]),
                            Other = Convert.ToInt32(reader["Other"])
                        });
                    }
                }
            }

            return result;
        }

    }

}
