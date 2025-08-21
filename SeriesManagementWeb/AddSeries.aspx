<%@ Page Language="C#" AutoEventWireup="true" Title="AddSeries" MasterPageFile="~/Site.Master" CodeBehind="AddSeries.aspx.cs" Inherits="SeriesManagementWeb.AddSeries" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <body class="bg-light">
        <div class="container mt-5">
            <div class="card shadow-lg p-4 mx-auto" style="max-width: 900px;">
                <h3 class="mb-4 text-center">Add Series</h3>
                <form id="seriesForm">
                    <div class="form-row">
                        <div class="row">
                            <div class="form-group col-md-4">
                                <label class="form-label">Series Name <span class="text-danger" style="color:red">*</span></label>
                                <input type="text" class="form-control" id="SeriesName" maxlength="250" required />
                            </div>
                            <div class="form-group col-md-4">
                                <label class="form-label">Series Type <span class="text-danger" style="color:red">*</span></label>
                                <select class="form-select" id="SeriesTypeId" required>
                                    <option value="">-- Select --</option>
                                    <option value="1">International</option>
                                    <option value="2">Domestic</option>
                                    <option value="3">Women</option>
                                    <option value="4">Mens</option>
                                </select>
                            </div>
                            <div class="form-group col-md-4">
                                <label class="form-label">Series Status <span class="text-danger" style="color:red">*</span></label>
                                <select class="form-select" id="SeriesStatusId" required>
                                    <option value="">-- Select --</option>
                                    <option value="1">Scheduled</option>
                                    <option value="2">Completed</option>
                                    <option value="3">Live</option>
                                    <option value="4">Abandon</option>
                                </select>
                            </div>
                        </div>
                    </div>

                    <div class="form-row">
                        <div class="row">
                            <div class="form-group col-md-4">
                                <label class="form-label">Match Status <span class="text-danger" style="color:red">*</span></label>
                                <select class="form-select" id="MatchStatusId" required>
                                    <option value="">-- Select --</option>
                                    <option value="1">Scheduled</option>
                                    <option value="2">Completed</option>
                                    <option value="3">Live</option>
                                    <option value="4">Abandon</option>
                                </select>
                            </div>
                            <div class="form-group col-md-4">
                                <label class="form-label">Match Format </label>
                                <select class="form-select" id="MatchFormatId">
                                    <option value="">-- Select --</option>
                                    <option value="1">ODI</option>
                                    <option value="2">TEST</option>
                                    <option value="3">T20</option>
                                    <option value="4">T10</option>
                                </select>
                            </div>
                            <div class="form-group col-md-4">
                                <label class="form-label">Series Match Type</label>
                                <select class="form-select" id="SeriesMatchTypeId">
                                    <option value="">-- Select --</option>
                                    <option value="1">ODI</option>
                                    <option value="2">TEST</option>
                                    <option value="3">T20I</option>
                                    <option value="4">LIST A</option>
                                    <option value="5">T20 (Domestic)</option>
                                    <option value="6">First class</option>
                                </select>
                            </div>
                        </div>
                    </div>

                    <div class="form-row">
                        <div class="row">
                            <div class="form-group col-md-4">
                                <label class="form-label">Gender <span class="text-danger" style="color:red">*</span></label>
                                <select class="form-select" id="GenderId" required>
                                    <option value="">-- Select --</option>
                                    <option value="1">Mens</option>
                                    <option value="2">Womens</option>
                                    <option value="3">Other</option>
                                </select>
                            </div>
                            <div class="form-group col-md-4">
                                <label class="form-label">Trophy Type <span class="text-danger" style="color:red">*</span></label>
                                <select class="form-select" id="TrophyTypeId" required>
                                    <option value="">-- Select --</option>
                                    <option value="1">Asia Cup</option>
                                    <option value="2">ICC World Cup T20</option>
                                </select>
                            </div>
                            <div class="form-group col-md-4">
                                <label class="form-label">Year <span class="text-danger" style="color:red">*</span></label>
                                <input type="text" class="form-control" id="Year" maxlength="4" required />
                            </div>
                        </div>
                    </div>

                    <div class="form-row">
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
                                <label class="form-label">Is Active <span class="text-danger" style="color:red">*</span></label>
                                <select class="form-select" id="IsActive" required>
                                    <option value="">-- Select --</option>
                                    <option value="1">Yes</option>
                                    <option value="0">No</option>
                                </select>
                            </div>
                        </div>
                    </div>

                    <div class="col-12">
                        <label class="form-label">Description </label>
                        <textarea class="form-control" id="Description" maxlength="500"></textarea>
                    </div>

                    <!-- Buttons -->
                    <div class="d-flex justify-content-center gap-2 mt-4">
                        <button type="button" class="btn btn-success" onclick="saveSeries()">Save</button>
                        <button type="reset" class="btn btn-secondary">Refresh</button>
                         <a  href="ManageSeries"  class="btn btn-danger">Cancel</a>
                    </div>
                </form>
            </div>
        </div>

      
        <script>
            function saveSeries() {
                // Collect values from form
                let data = {
                    seriesName: $("#SeriesName").val(),
                    seriesType: $("#SeriesTypeId option:selected").text(), // send text like "International"
                    seriesStatus: $("#SeriesStatusId option:selected").text(),
                    matchStatus: $("#MatchStatusId option:selected").text(),
                    matchFormat: $("#MatchFormatId option:selected").text(),
                    seriesMatchType: $("#SeriesMatchTypeId option:selected").text(),
                    gender: $("#GenderId option:selected").text(),
                    year: $("#Year").val(),
                    trophyType: $("#TrophyTypeId option:selected").text(),
                    seriesStartDate: $("#SeriesStartDate").val(),
                    seriesEndDate: $("#SeriesEndDate").val(),
                    isActive: $("#IsActive").val() === "1" ? true : false,
                    description: $("#Description").val()
                };

                // AJAX POST request
                $.ajax({
                    url: "https://localhost:7019/api/Series/Create",
                    type: "POST",
                    contentType: "application/json",
                    data: JSON.stringify(data),
                    success: function (res) {
                        alert(res.message || "Series saved successfully!");
                        window.location = "ManageSeries.aspx";
                    },
                    error: function (err) {
                        console.error(err);
                        alert("Error: " + "all Feild Requied  ");
                    }
                });
            }
        </script>
    </body>
</asp:Content>