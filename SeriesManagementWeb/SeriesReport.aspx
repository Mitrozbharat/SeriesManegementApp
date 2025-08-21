
<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="SeriesReport.aspx.cs" Inherits="SeriesManagementWeb.SeriesReport" MasterPageFile="~/Site.Master" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Series Report</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 20px;
        }
        table {
            border-collapse: collapse;
            width: 100%;
            margin-top: 20px;
        }
        th, td {
            border: 1px solid #ddd;
            padding: 8px;
            text-align: center;
        }
        th {
            background-color: #f2f2f2;
        }
        tr:nth-child(even) {
            background-color: #f9f9f9;
        }
        tr:hover {
            background-color: #f5f5f5;
        }
        #ddlYears {
            width: 200px;
            height: 100px;
        }
     
        #reportContainer {
            margin-top: 20px;
        }
    </style>
</head>
<body>
    <div class="my-3">
      <a  href="ManageSeries"  class="btn btn-danger">Back</a>   

    </div>

    <h2>Series Report</h2>

  <label>Select Years:</label>
        <div class="year-checkboxes">
            <label><input type="checkbox" class="year-checkbox" value="2019"> 2019</label>
            <label><input type="checkbox" class="year-checkbox" value="2020"> 2020</label>
            <label><input type="checkbox" class="year-checkbox" value="2021"> 2021</label>
            <label><input type="checkbox" class="year-checkbox" value="2022"> 2022</label>
            <label><input type="checkbox" class="year-checkbox" value="2023"> 2023</label>
            <label><input type="checkbox" class="year-checkbox" value="2024"> 2024</label>
             <label><input type="checkbox" class="year-checkbox" checked value="2025" /> 2025 </label>
        </div>

    <button type="button" id="btnLoad">Load Report</button>
    <button type="button" id="btnClear">Clear</button>

    <div id="reportContainer"></div>
        <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

    <script>

        $(document).ready(function () {
            $(document).ready(function () {
                // Trigger button click automatically on page load
                $("#btnLoad").trigger("click");

                $(".year-checkbox").change(function () {
                    $("#btnLoad").trigger("click");
                });
            });

        });

        $(document).ready(function () {
            
            
            $('#btnLoad').click(function () {
                var selectedYears = $('.year-checkbox:checked').map(function () {
                    return this.value;
                }).get();

                if (!selectedYears || selectedYears.length === 0) {
                    $('#reportContainer').html('<p style="color:red;">Please select at least one year.</p>');
                    return;

               }


                $.ajax({
                    url: 'https://localhost:7019/api/Series/GetSeriesReport',
                    type: 'GET',
                    data: { years: selectedYears },
                    traditional: true,
                    success: function (data) {
                        console.log(data); // For debugging
                        renderTable(data, selectedYears);
                    },
                    error: function (xhr) {
                        $('#reportContainer').html('<p style="color:red;">Error: ' + xhr.responseText + '</p>');
                    }
                });
            });


            // Clear Selection
            $('#btnClear').click(function () {
                $('.year-checkbox').prop('checked', false);
                $('#reportContainer').empty();
            });

                // The renderTable function remains the same as in the previous response
           

            function renderTable(data, years) {
                if (!data || data.length === 0) {
                    $('#reportContainer').html('<p>No data found.</p>');
                    return;
                }

                // Start building the table
                var table = '<table><thead><tr><th>Match Format</th>';

                // Add year headers with Men, Women, Other sub-columns
                years.forEach(function (year) {
                    table += `<th colspan="3">Year ${year}</th>`;
                });
                table += '</tr><tr><th></th>';
                years.forEach(function () {
                    table += '<th>Men</th><th>Women</th><th>Other</th>';
                });
                table += '</tr></thead><tbody>';

                // Group data by match format
                var grouped = {};
                data.forEach(function (row) {
                    if (!grouped[ row.matchFormat ]) {
                        grouped[ row.matchFormat ] = {};
                    }
                    grouped[ row.matchFormat ][ row.year ] = row;
                });

                // Define match formats to maintain order
                var matchFormats = [ 'ODI', 'TEST', 'T20', 'T10' ];
                matchFormats.forEach(function (match) {
                    table += `<tr><td>${match}</td>`;
                    years.forEach(function (year) {
                        var row = grouped[ match ] && grouped[ match ][ year ];
                        if (row) {
                            table += `<td>${row.men}</td><td>${row.women}</td><td>${row.other}</td>`;
                        } else {
                            table += '<td>0</td><td>0</td><td>0</td>';
                        }
                    });
                    table += '</tr>';
                });

                // Add Totals row
                table += '<tr><td><strong>Total</strong></td>';
                years.forEach(function (year) {
                    var totalMen = 0, totalWomen = 0, totalOther = 0;
                    data.forEach(function (row) {
                        if (row.year == year) {
                            totalMen += row.men;
                            totalWomen += row.women;
                            totalOther += row.other;
                        }
                    });
                    table += `<td><strong>${totalMen}</strong></td><td><strong>${totalWomen}</strong></td><td><strong>${totalOther}</strong></td>`;
                });
                table += '</tr>';

                table += '</tbody></table>';

                // Render the table
                $('#reportContainer').html(table);
            }
        });
    
    </script>
</body>

</asp:Content>
