using Microsoft.Data.SqlClient;
using Microsoft.Extensions.Configuration;
using SeriesApp.DAL.Interfaces;
using SeriesApp.Domain.Entities;
using System.Data;

public class SeriesRepository : ISeriesRepo
{
    private readonly string _connectionString;

    public SeriesRepository(IConfiguration configuration)
    {
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

        try
        {
            await conn.OpenAsync();
            await cmd.ExecuteNonQueryAsync();

            int newId = (outId.Value == DBNull.Value) ? 0 : Convert.ToInt32(outId.Value);
            return newId;
        }
        catch (Exception ex)
        {
            await LogErrorAsync(ex, nameof(AddSeriesAsync));
            throw;
        }
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

        var rowsAffectedParam = new SqlParameter("@RowsAffected", SqlDbType.Int)
        {
            Direction = ParameterDirection.Output
        };
        cmd.Parameters.Add(rowsAffectedParam);

        try
        {
            await conn.OpenAsync();
            await cmd.ExecuteNonQueryAsync();

            int rowsAffected = (int)rowsAffectedParam.Value;
            return rowsAffected > 0;
        }
        catch (Exception ex)
        {
            await LogErrorAsync(ex, nameof(UpdateSeriesAsync));
            throw;
        }
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

        try
        {
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
        catch (Exception ex)
        {
            await LogErrorAsync(ex, nameof(SearchSeriesAsync));
            throw;
        }
    }

    public async Task<IEnumerable<tbl_Series>> GetAllSeries()
    {
        var seriesList = new List<tbl_Series>();

        using var conn = new SqlConnection(_connectionString);
        using var cmd = new SqlCommand("SELECT * FROM tbl_Series", conn)
        {
            CommandType = CommandType.Text
        };

        try
        {
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
        catch (Exception ex)
        {
            await LogErrorAsync(ex, nameof(GetAllSeries));
            throw;
        }
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

        try
        {
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
        catch (Exception ex)
        {
            await LogErrorAsync(ex, nameof(SearchByAsync));
            throw;
        }
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
        catch (Exception ex)
        {
            await transaction.RollbackAsync();
            await LogErrorAsync(ex, nameof(DeleteAsync));
            throw;
        }
    }

    public List<SeriesReport> GetSeriesReport(int[] years)
    {
        var result = new List<SeriesReport>();

        using (var conn = new SqlConnection(_connectionString))
        using (var cmd = new SqlCommand("dbo.GetMatchFormatStatsByYear", conn))
        {
            cmd.CommandType = CommandType.StoredProcedure;

            string yearsParam = string.Join(",", years);
            cmd.Parameters.AddWithValue("@Years", yearsParam);

            try
            {
                conn.Open();
                using (var reader = cmd.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        result.Add(new SeriesReport
                        {
                            MatchFormat = reader["MatchFormat"].ToString(),
                            Year = Convert.ToInt32(reader["Year"]),
                            Men = Convert.ToInt32(reader["MenMatches"]),
                            Women = Convert.ToInt32(reader["WomenMatches"]),
                            Other = Convert.ToInt32(reader["OtherMatches"])
                        });
                        Console.ForegroundColor = ConsoleColor.White;
                        Console.Write(reader["MatchFormat"].ToString());
                    }
                }
            }
            catch (Exception ex)
            {
                LogError(ex, nameof(GetSeriesReport));
                throw;
            }
        }

        return result;
    }

    private async Task LogErrorAsync(Exception ex, string methodName)
    {
        try
        {
            using var conn = new SqlConnection(_connectionString);
            using var cmd = new SqlCommand(
                "INSERT INTO ErrorLogs (OccurredOn, Message, StackTrace, AdditionalInfo) VALUES (@occurredOn, @message, @stackTrace, @additionalInfo)", conn);

            cmd.Parameters.AddWithValue("@occurredOn", DateTime.UtcNow);
            cmd.Parameters.AddWithValue("@message", ex.Message);
            cmd.Parameters.AddWithValue("@stackTrace", ex.StackTrace ?? "");
            cmd.Parameters.AddWithValue("@additionalInfo", methodName);

            await conn.OpenAsync();
            await cmd.ExecuteNonQueryAsync();
        }
        catch
        {
            // Swallow logging errors to avoid recursive failures
        }
    }

    private void LogError(Exception ex, string methodName)
    {
        try
        {
            using var conn = new SqlConnection(_connectionString);
            using var cmd = new SqlCommand(
                "INSERT INTO ErrorLogs (OccurredOn, Message, StackTrace, AdditionalInfo) VALUES (@occurredOn, @message, @stackTrace, @additionalInfo)", conn);

            cmd.Parameters.AddWithValue("@occurredOn", DateTime.UtcNow);
            cmd.Parameters.AddWithValue("@message", ex.Message);
            cmd.Parameters.AddWithValue("@stackTrace", ex.StackTrace ?? "");
            cmd.Parameters.AddWithValue("@additionalInfo", methodName);

            conn.Open();
            cmd.ExecuteNonQuery();
        }
        catch
        {
            // Swallow logging errors to avoid recursive failures
        }
    }
}