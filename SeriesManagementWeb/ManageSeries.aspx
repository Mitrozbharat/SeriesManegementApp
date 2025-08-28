<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/Site.Master" CodeBehind="ManageSeries.aspx.cs" Inherits="SeriesManagementWeb.ManageSeries" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    
    
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdn.datatables.net/1.10.24/js/jquery.dataTables.min.js"></script>
    <script src="https://cdn.datatables.net/1.10.24/js/dataTables.bootstrap4.min.js"></script>

    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f8f9fa;
        }

        .container {
            margin-top: 20px;
        }

        .search-panel {
            background-color: #fff;
            padding: 20px;
            border-radius: 5px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            margin-bottom: 20px;
        }

        .table-container {
            background-color: #fff;
            padding: 20px;
            border-radius: 5px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }

        .btn {
            margin-right: 5px;
        }

        .error-message {
            color: red;
            margin-top: 10px;
            display: none;
        }
    </style>

    <form id="form1">
        <div class="container">
            <!-- Search Panel -->
            <div class="search-panel">
                <div class="row">
                    <div class="col-6">
                        <h4>Search Series</h4>
                    </div>
                    <div class="col-6 d-flex justify-content-end ">
                        <a href="SeriesReport" class="btn btn-outline-primary m-1">Report</a>
                    </div>
                </div>
                <div class="form-row">
                    <div class="row">
                        <div class="form-group col-md-4">
                            <label for="txtSeriesAPIId">Series ID</label>
                            <asp:TextBox ID="txtSeriesAPIId" runat="server" CssClass="form-control" MaxLength="10"></asp:TextBox>
                        </div>
                        <div class="form-group col-md-4">
                            <label for="txtSeriesName">Series Name</label>
                            <asp:TextBox ID="txtSeriesName" runat="server" CssClass="form-control" MaxLength="250"></asp:TextBox>
                        </div>
                        <div class="form-group col-md-4">
                            <label for="ddlSeriesType">Series Type</label>
                            <asp:DropDownList ID="ddlSeriesType" runat="server" CssClass="form-control">
                                <asp:ListItem Value="">Select</asp:ListItem>
                                <asp:ListItem Value="International">International</asp:ListItem>
                                <asp:ListItem Value="Domestic">Domestic</asp:ListItem>
                                <asp:ListItem Value="Women">Women</asp:ListItem>
                                <asp:ListItem Value="Mens">Mens</asp:ListItem>
                            </asp:DropDownList>
                        </div>
                    </div>
                </div>
                <div class="form-row">
                    <div class="row my-2">
                        <div class="form-group col-md-4">
                            <label for="txtSeriesStartDate">Start Date</label>
                            <asp:TextBox ID="txtSeriesStartDate" runat="server" CssClass="form-control" TextMode="Date"></asp:TextBox>
                        </div>
                        <div class="form-group col-md-4">
                            <label for="txtSeriesEndDate">End Date</label>
                            <asp:TextBox ID="txtSeriesEndDate" runat="server" CssClass="form-control" TextMode="Date"></asp:TextBox>
                        </div>
                        <div class="form-group col-md-4">
                            <label for="ddlSortBy">Sort By</label>
                            <asp:DropDownList ID="ddlSortBy" runat="server" CssClass="form-control">
                                <asp:ListItem Value="">--select--</asp:ListItem>
                                <asp:ListItem Value="SeriesStartDate ASC">Start Date Asc</asp:ListItem>
                                <asp:ListItem Value="SeriesStartDate DESC" Selected="True">Start Date Desc</asp:ListItem>
                                
                            </asp:DropDownList>
                        </div>

                    </div>
                    <div class="form-group d-flex justify-content-around mt-4 mt-md-2">
                        <asp:Button ID="btnAddSeries" runat="server" Text="Add Series" CssClass="btn btn-primary" OnClientClick="window.location.href='AddSeries.aspx?Mode=A'; return false;" />
                        <asp:Button ID="btnSearch" runat="server" Text="Search" CssClass="btn btn-success" OnClientClick="searchSeries(); return false;" />
                        <asp:Button ID="btnRefresh" runat="server" Text="Refresh" CssClass="btn btn-secondary" OnClientClick="resetForm(); return false;" />
                        <asp:HyperLink
                            ID="btnCancel"
                            runat="server"
                            NavigateUrl="~/Default.aspx"
                            CssClass="btn btn-danger">Cancel
                        </asp:HyperLink>
                    </div>

                </div>
                <div id="errorMessage" class="error-message"></div>
            </div>
     </form>

            <!-- Series Table -->
            <div class="table-container">
                <table id="seriesTable" class="table table-bordered table-striped">
                    <thead>
                        <tr>
                            <th>Series ID</th>
                            <th>Series Name</th>
                            <th>Series Type</th>
                            <th>Match Type</th>
                            <th>Gender</th>
                            <th>Year</th>
                            <th>Tropy Type</th>
                            <th>Start Date</th>
                            <th>End Date</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody></tbody>
                </table>

            </div>
       
    

    <!-- Modal -->
    <!-- Series Modal -->
    <div class="modal fade" id="seriesModal" tabindex="-1" aria-labelledby="seriesModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-xl modal-dialog-scrollable">
            <div class="modal-content">
                <div class="modal-header bg-primary text-white">
                    <h5 class="modal-title" id="seriesModalLabel">Series Details</h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>

                <div class="modal-body">
                    <!-- ================= FORM ================= -->
                    <form id="seriesForm">
                        <div class="form-row">
                            <div class="row">

                                <div class="form-group col-md-4">
                                    <label class="form-label">Series Name <span class="text-danger">*</span></label>
                                    <input type="text" class="form-control" id="SeriesName" maxlength="250" required />
                                </div>
                                <div class="form-group col-md-4">
                                    <label class="form-label">Series Type <span class="text-danger">*</span></label>
                                    <select class="form-select" id="SeriesTypeId" required>
                                        <option value="">-- Select --</option>
                                        <option value="International">International</option>
                                        <option value="Domestic">Domestic</option>
                                        <option value="Women">Women</option>
                                        <option value="Mens">Mens</option>
                                    </select>
                                </div>
                                <div class="form-group col-md-4">
                                    <label class="form-label">Series Status <span class="text-danger">*</span></label>
                                    <select class="form-select" id="SeriesStatusId" required>
                                        <option value="">-- Select --</option>
                                        <option value="Scheduled">Scheduled</option>
                                        <option value="Completed">Completed</option>
                                        <option value="Live">Live</option>
                                        <option value="Abandon">Abandon</option>
                                    </select>
                                </div>
                            </div>
                        </div>

                        <div class="form-row mt-3">
                            <div class="row">
                                <div class="form-group col-md-4">
                                    <label class="form-label">Match Status <span class="text-danger">*</span></label>
                                    <select class="form-select" id="MatchStatusId" required>
                                        <option value="">-- Select --</option>
                                        <option value="Scheduled">Scheduled</option>
                                        <option value="Completed">Completed</option>
                                        <option value="Live">Live</option>
                                        <option value="Abandon">Abandon</option>
                                    </select>
                                </div>
                                <div class="form-group col-md-4">
                                    <label class="form-label">Match Format </label>
                                    <select class="form-select" id="MatchFormatId">
                                        <option value="">-- Select --</option>
                                        <option value="ODI">ODI</option>
                                        <option value="TEST">TEST</option>
                                        <option value="T20">T20</option>
                                        <option value="T10">T10</option>
                                    </select>
                                </div>
                                <div class="form-group col-md-4">
                                    <label class="form-label">Series Match Type</label>
                                    <select class="form-select" id="SeriesMatchTypeId">
                                        <option value="">-- Select --</option>
                                        <option value="ODI">ODI</option>
                                        <option value="TEST">TEST</option>
                                        <option value="T20I">T20I</option>
                                        <option value="LIST A">LIST A</option>
                                        <option value="T20 (Domestic)">T20 (Domestic)</option>
                                        <option value="First class">First class</option>
                                    </select>
                                </div>
                            </div>
                        </div>

                        <div class="form-row mt-3">
                            <div class="row">
                                <div class="form-group col-md-4">
                                    <label class="form-label">Gender <span class="text-danger">*</span></label>
                                    <select class="form-select" id="GenderId" required>
                                        <option value="">-- Select --</option>
                                        <option value="Mens">Mens</option>
                                        <option value="Womens">Womens</option>
                                        <option value="Other">Other</option>
                                    </select>
                                </div>
                                <div class="form-group col-md-4">
                                    <label class="form-label">Trophy Type <span class="text-danger">*</span></label>
                                    <select class="form-select" id="TrophyTypeId" required>
                                        <option value="">-- Select --</option>
                                        <option value="Asia Cup">Asia Cup</option>
                                        <option value="ICC World Cup T20">ICC World Cup T20</option>
                                    </select>
                                </div>
                                <div class="form-group col-md-4">
                                    <label class="form-label">Year <span class="text-danger">*</span></label>
                                    <input type="text" class="form-control" id="Year" maxlength="4" required />
                                </div>
                            </div>
                        </div>

                        <div class="form-row mt-3">
                            <div class="row">
                                <div class="form-group col-md-4">
                                    <label class="form-label">Series Start Date</label>
                                    <input type="date" class="form-control" id="SeriesStartDate" required />
                                </div>
                                <div class="form-group col-md-4">
                                    <label class="form-label">Series End Date</label>
                                    <input type="date" class="form-control" id="SeriesEndDate" required />
                                </div>
                                <div class="form-group col-md-4">
                                    <label class="form-label">Is Active <span class="text-danger">*</span></label>
                                    <select class="form-select" id="IsActive" required>
                                        <option value="">-- Select --</option>
                                        <option value="1">Yes</option>
                                        <option value="0">No</option>
                                    </select>
                                </div>
                            </div>
                        </div>

                        <div class="form-row mt-3">
                            <div class="col-12">
                                <label class="form-label">Description </label>
                                <textarea class="form-control" id="Description" maxlength="500"></textarea>
                            </div>
                        </div>

                        <!-- Buttons -->
                        <div class="d-flex justify-content-center gap-2 mt-4">
                            <button type="button" class="btn btn-success" onclick="updateSeries()">Save</button>
                            <button type="reset" class="btn btn-secondary">Refresh</button>
                            <a href="ManageSeries" class="btn btn-danger">Cancel</a>
                        </div>
                    </form>
                    <!-- ================= END FORM ================= -->
                </div>
            </div>
        </div>
    </div>


    <script>


        $(document).ready(function () {
            // Client-side validation for SeriesId
            $('#MainContent_txtSeriesAPIId').on('input', function () {
                this.value = this.value.replace(/[^0-9]/g, '');
            });

            loaddatatable();

            // Search button click
            window.searchSeries = function () {
                var seriesId = $('#MainContent_txtSeriesAPIId').val();
                var startDate = $('#MainContent_txtSeriesStartDate').val();
                var endDate = $('#MainContent_txtSeriesEndDate').val();

                // Validate SeriesId
                if (seriesId && isNaN(parseInt(seriesId))) {
                    $('#errorMessage').text('Series ID must be a number.').show();
                    return;
                }

                // Validate date range
                if (startDate && endDate && new Date(startDate) > new Date(endDate)) {
                    $('#errorMessage').text('Start date cannot be after end date.').show();
                    return;
                }

                $('#errorMessage').hide();
                table.ajax.reload();
                $('#MainContent_txtSeriesAPIId').val('');
                $('#MainContent_txtSeriesName').val('');

            };

            // Reset form
            window.resetForm = function () {
                $('#MainContent_txtSeriesAPIId').val('');
                $('#MainContent_txtSeriesName').val('');
                $('#MainContent_ddlSeriesType').val('');
                $('#MainContent_txtSeriesStartDate').val('');
                $('#MainContent_txtSeriesEndDate').val('');
                $('#MainContent_ddlSortBy').val('');

                $('#errorMessage').hide();
                table.ajax.reload();
            };

            // Delete series
            $('#seriesTable').on('click', '.delete-series', function () {
                var seriesId = $(this).data('id');
                if (confirm('Are you sure you want to delete this series?')) {
                    $.ajax({
                        url: 'https://localhost:7019/api/Series/' + seriesId,
                        method: 'DELETE',
                        success: function (response) {
                            table.ajax.reload();
                            alert(response.message || 'Series deleted successfully.');
                        },
                        error: function (xhr, error, thrown) {
                            $('#errorMessage').text('Error deleting series: ' + (xhr.responseJSON?.message || xhr.responseText)).show();
                        }
                    });
                }
            });
        });



        function loaddatatable() {

            // Initialize DataTable
            var table = $('#seriesTable').DataTable({
                ajax: {
                    url: 'https://localhost:7019/api/Series/Search',
                    type: 'GET',
                    dataType: 'json',
                    data: function (d) {
                        var seriesId = $('#MainContent_txtSeriesAPIId').val();
                        d.seriesId = seriesId ? parseInt(seriesId) : null;
                        d.seriesName = $('#MainContent_txtSeriesName').val() || null;
                        d.seriesType = $('#MainContent_ddlSeriesType').val() || null;
                        d.startFrom = $('#MainContent_txtSeriesStartDate').val() || null;
                        d.endTo = $('#MainContent_txtSeriesEndDate').val() || null;
                        d.sortBy = $('#MainContent_ddlSortBy').val() || null;

                        // 🔹 Print params before sending to server
                        console.log("Params sent to server:", d);
                    },
                    dataSrc: function (json) {
                        // 🔹 Print response from server
                        console.log("Response from server:", json);
                      
                        return json; // must return data array
                    },
                    error: function (xhr, error, thrown) {
                        var message = xhr.responseJSON?.message || xhr.responseText || 'An error occurred while loading data.';
                        $('#errorMessage').text('Error loading data: ' + message).show();
                        console.error('DataTable error:', xhr.status, xhr.responseText, thrown);
                    }
                },

                columns: [
                    {
                        data: null, // no backend field
                        render: function (data, type, row, meta) {
                            return meta.row + 1; // 🔹 auto-generate serial number
                        }
                    },
                    {
                        data: 'seriesName',
                        render: function (data, type, row) {

                            var encryptedParams = btoa('Mode=E&Sid=' + row.seriesId);
                            return '<a href="UpdateSeries.aspx?q=' + encryptedParams + '">' + data + '</a>';
                            //return `<a href="#" class="openSeriesModal" data-bs-toggle="modal" data-bs-target="#seriesModal" data-row='${JSON.stringify(row)}'>${data}</a>`;
                        }
                    },
                    { data: 'seriesType' },

                    { data: 'seriesMatchType' },
                    { data: 'gender' },

                    { data: 'year' },

                    { data: 'trophyType' },

                    {
                        data: 'seriesStartDate',
                        render: function (data) {
                            if (data && data !== '0001-01-01T00:00:00') {
                                var date = new Date(data);
                                return date.toLocaleDateString('en-GB'); // Format as DD/MM/YYYY
                            }
                            return 'Not Set';
                        }
                    },


                    {
                        data: 'seriesEndDate',
                        render: function (data) {
                            if (data && data !== '0001-01-01T00:00:00') {
                                var date = new Date(data);
                                return date.toLocaleDateString('en-GB'); // Format as DD/MM/YYYY
                            }
                            return 'Not Set';
                        }
                    },
                    {
                        data: null,
                        render: function (data, type, row) {
                            return '<button class="btn btn-danger btn-sm delete-series" onclick="seriesDelete(row.seriesId)" data-id="' + row.seriesId + '">Delete Series</button>';
                        }
                    }
                ],

                ordering: false,
                order: [],
                responsive: true,
                pageLength: 10,
                language: {
                    emptyTable: "No series found matching the criteria."
                }
            });

        }



        let newseriesId;
        $(document).on("click", ".openSeriesModal", function (e) {
            e.preventDefault();

            // Get row data from attribute
            var rowData = $(this).data("row");
            console.log(rowData);
            newseriesId = rowData.seriesId;
          
            $("#seriesId").val(rowData.seriesId);
            $("#SeriesName").val(rowData.seriesName);
            $("#SeriesTypeId").val(rowData.seriesType);
            $("#SeriesStatusId").val(rowData.seriesStatus);
            $("#MatchStatusId").val(rowData.matchStatus);
            $("#SeriesMatchTypeId").val(rowData.seriesMatchType);
            $("#MatchFormatId").val(rowData.matchFormat);
            $("#TrophyTypeId").val(rowData.trophyType);
            $('#GenderId').val(rowData.gender);
            $('#Year').val(rowData.year);
            $('#IsActive').val(rowData.isActive ? "1" : "0");
            $("#SeriesStartDate").val(rowData.seriesStartDate ? rowData.seriesStartDate.split("T")[ 0 ] : "");
            $("#SeriesEndDate").val(rowData.seriesEndDate ? rowData.seriesEndDate.split("T")[ 0 ] : "");
            $("#Description").val(rowData.description || "");

            $("#seriesModal").modal("show");



        
        });


        function updateSeries() {
            // Collect values from form
            let data = {
                seriesId: newseriesId,
                seriesName: $("#SeriesName").val(),
                seriesType: $("#SeriesTypeId").val(), // send text like "International"
                seriesStatus: $("#SeriesStatusId").val(),
                matchStatus: $("#MatchStatusId").val(),
                matchFormat: $("#MatchFormatId").val(),
                seriesMatchType: $("#SeriesMatchTypeId").val(),
                gender: $("#GenderId").val(),
                year: $("#Year").val(),
                trophyType: $("#TrophyTypeId").val(),
                seriesStartDate: $("#SeriesStartDate").val(),
                seriesEndDate: $("#SeriesEndDate").val(),
                isActive: $("#IsActive").val() === "1" ? true : false,
                description: $("#Description").val()

            };

            $.ajax({
                url: "https://localhost:7019/api/Series/update/" + newseriesId,
                type: "PUT",
                contentType: "application/json",
                data: JSON.stringify(data),
                success: function (res) {

                    //window.location = "ManageSeries.aspx";
                    $("#seriesModal").modal("hide");
                    window.location.reload();


                },
                error: function (err) {

                    alert("Error: " + (err.responseText || err.statusText));
                }
            });
            // AJAX POST request

        }

    </script>






</asp:Content>
