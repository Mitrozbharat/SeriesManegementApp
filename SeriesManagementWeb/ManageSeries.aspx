<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/Site.Master" CodeBehind="ManageSeries.aspx.cs" Inherits="SeriesManagementWeb.ManageSeries" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
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
                <h4>Search Series</h4>
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
                                <asp:ListItem Value="SeriesIdAsc">Series ID Asc</asp:ListItem>
                                <asp:ListItem Value="SeriesIdDesc">Series ID Desc</asp:ListItem>
                                <asp:ListItem Value="SeriesNameAsc">Series Name Asc</asp:ListItem>
                                <asp:ListItem Value="SeriesNameDesc">Series Name Desc</asp:ListItem>
                                <asp:ListItem Value="SeriesTypeAsc">Series Type Asc</asp:ListItem>
                                <asp:ListItem Value="SeriesTypeDesc">Series Type Desc</asp:ListItem>
                                <asp:ListItem Value="SeriesStartDate ASC">Start Date Asc</asp:ListItem>
                                <asp:ListItem Value="SeriesStartDate DESC" Selected="True">Start Date Desc</asp:ListItem>
                                <asp:ListItem Value="SeriesEndDateAsc">End Date Asc</asp:ListItem>
                                <asp:ListItem Value="SeriesEndDateDesc">End Date Desc</asp:ListItem>
                            </asp:DropDownList>
                        </div>

                    </div>
                    <div class="form-group d-flex justify-content-around mt-4 mt-md-2">
                        <asp:Button ID="btnAddSeries" runat="server" Text="Add Series" CssClass="btn btn-primary" OnClientClick="window.location.href='AddSeries.aspx?Mode=A'; return false;" />
                        <asp:Button ID="btnSearch" runat="server" Text="Search" CssClass="btn btn-success" OnClientClick="searchSeries(); return false;" />
                        <asp:Button ID="btnRefresh" runat="server" Text="Refresh" CssClass="btn btn-secondary" OnClientClick="resetForm(); return false;" />
                        <asp:Button ID="btnCancel" runat="server" Text="Cancel" CssClass="btn btn-danger" OnClientClick="resetForm(); return false;" />
                    </div>
                </div>
                <div id="errorMessage" class="error-message"></div>
            </div>

            <!-- Series Table -->
            <div class="table-container">
                <table id="seriesTable" class="table table-bordered table-striped">
                    <thead>
                        <tr>
                            <th>Series ID</th>
                            <th>Series Name</th>
                            <th>Series Type</th>
                            <th>Start Date</th>
                            <th>End Date</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody></tbody>
                </table>

              
            </div>
        </div>
    </form>

    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdn.datatables.net/1.10.24/js/jquery.dataTables.min.js"></script>
    <script src="https://cdn.datatables.net/1.10.24/js/dataTables.bootstrap4.min.js"></script>

    <script>
        $(document).ready(function () {
            // Client-side validation for SeriesId
            $('#MainContent_txtSeriesAPIId').on('input', function () {
                this.value = this.value.replace(/[^0-9]/g, '');
            });

           

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
                        d.sortBy = $('#MainContent_ddlSortBy').val() || 'SeriesStartDate DESC';
                        d.includeInactive = $('#chkIncludeInactive').is(':checked');
                    },
                    dataSrc: '',
                    error: function (xhr, error, thrown) {
                        var message = xhr.responseJSON?.message || xhr.responseText || 'An error occurred while loading data.';
                        $('#errorMessage').text('Error loading data: ' + message).show();
                        console.error('DataTable error:', xhr.status, xhr.responseText, thrown);
                    }

                },

                columns: [
                    { data: 'seriesId' },
                    {
                        data: 'seriesName',
                        render: function (data, type, row) {
                            var encryptedParams = btoa('Mode=E&Sid=' + row.seriesId);
                            return '<a href="UpdateSeries.aspx?q=' + encryptedParams + '">' + data + '</a>';
                        }
                    },
                    { data: 'seriesType' },
                    //{ data:'seriesStatus' },

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
                            return '<button class="btn btn-danger btn-sm delete-series" data-id="' + row.seriesId + '">Mark Inactive</button>';
                        }
                    },

                ],

                responsive: true,
                pageLength: 10,
                language: {
                    emptyTable: "No series found matching the criteria."
                }
            });

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
            };

            // Reset form
            window.resetForm = function () {
                $('#MainContent_txtSeriesAPIId').val('');
                $('#MainContent_txtSeriesName').val('');
                $('#MainContent_ddlSeriesType').val('');
                $('#MainContent_txtSeriesStartDate').val('');
                $('#MainContent_txtSeriesEndDate').val('');
                $('#MainContent_ddlSortBy').val('SeriesStartDate DESC');
                $('#chkIncludeInactive').prop('checked', false);
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
    </script>
</asp:Content>
