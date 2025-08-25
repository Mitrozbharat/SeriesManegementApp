<%@ Page Language="C#" AutoEventWireup="true"
    MasterPageFile="~/Site.Master"
    CodeFile="UpdateSeries.aspx.cs"
    Inherits="SeriesManagementWeb.UpdateSeries" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">

      <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

    <body class="bg-light">
        <div class="container">


            <div class="card shadow-lg p-4 mx-auto" style="max-width: 900px;">
                
                <div class="row">
                    <div class="col-md-2">
                        <a href="ManageSeries" class="btn btn-outline-danger m-1">Back</a>
                    </div>
                     <div class="col-md-8">
                            <h3 id="pageTitle" class="mb-4 text-center">Add Series</h3>

                             </div>
                </div>

                   
             
                <form id="seriesForm">
                    <!-- Row 1 -->
                    <div class="row">

                        <div class="form-group col-md-4">
                            <label class="form-label">Series Name</label>   
                            <input type="number" id="seriesId"  style="display:none"/>
      
                            <input type="text" class="form-control" id="SeriesName" maxlength="250" required />
                        </div>
                        <div class="form-group col-md-4">
                            <label class="form-label">Series Type</label>
                            <select class="form-select" id="SeriesTypeId" required >
                                <option value="">-- Select --</option>
                                <option value="1">International</option>
                                <option value="2">Domestic</option>
                                <option value="3">Women</option>
                                <option value="4">Mens</option>
                            </select>
                        </div>
                        <div class="form-group col-md-4">
                            <label class="form-label">Series Status</label>
                            <select class="form-select" id="SeriesStatusId" required>
                                <option value="">-- Select --</option>
                                <option value="1">Scheduled</option>
                                <option value="2">Completed</option>
                                <option value="3">Live</option>
                                <option value="4">Abandon</option>
                            </select>
                        </div>
                    </div>

                    <!-- Row 2 -->
                    <div class="row">
                        <div class="form-group col-md-4">
                            <label class="form-label">Match Status</label>
                            <select class="form-select" id="MatchStatusId" required>
                                <option value="">-- Select --</option>
                                <option value="1">Scheduled</option>
                                <option value="2">Completed</option>
                                <option value="3">Live</option>
                                <option value="4">Abandon</option>
                            </select>
                        </div>
                        <div class="form-group col-md-4">
                            <label class="form-label">Match Format</label>
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

                    <!-- Row 3 -->
                    <div class="row">
                        <div class="form-group col-md-4">
                            <label class="form-label">Gender</label>
                            <select class="form-select" id="GenderId" required>
                                <option value="">-- Select --</option>
                                <option value="1">Mens</option>
                                <option value="2">Womens</option>
                                <option value="3">Other</option>
                            </select>
                        </div>
                        <div class="form-group col-md-4">
                            <label class="form-label">Trophy Type</label>
                            <select class="form-select" id="TrophyTypeId" required>
                                <option value="">-- Select --</option>
                                <option value="1">Asia Cup</option>
                                <option value="2">ICC World Cup T20</option>
                            </select>
                        </div>
                        <div class="form-group col-md-4">
                            <label class="form-label">Year</label>
                            <input type="text" class="form-control" id="Year" maxlength="4" required />
                        </div>
                    </div>

                    <!-- Row 4 -->
                    <div class="row">
                         <div id="errorMessage" class="error-message"></div>

                        <div class="form-group col-md-4">
                            <label class="form-label">Series Start Date</label>
                            <input type="date" class="form-control" id="SeriesStartDate" required />
                        </div>
                        <div class="form-group col-md-4">

                            <label class="form-label">Series End Date</label>
                            <input type="date" class="form-control" id="SeriesEndDate" required />
                        </div>
                        <div class="form-group col-md-4">
                            <label class="form-label">Is Active</label>
                            <select class="form-select" id="IsActive" required>
                                <option value="">-- Select --</option>
                                <option value="1">Yes</option>
                                <option value="0">No</option>
                            </select>
                        </div>
                    </div>

                    <!-- Description -->
                    <div class="col-12">
                        <label class="form-label">Description</label>
                        <textarea class="form-control" id="Description" maxlength="500"></textarea>
                    </div>

                    <!-- Buttons -->
                    <div class="d-flex justify-content-center gap-2 mt-4">
                        <button type="button" class="btn btn-success" onclick="saveSeriesFun()">Save</button>
                        <button type="reset" class="btn btn-secondary">Refresh</button>
                        <button type="button" class="btn btn-danger" onclick="window.location='ManageSeries.aspx'">Cancel</button>
                    </div>

                </form>
            </div>
        </div>

    
        <script>
            let id;
            // Helpers
            function getQueryParam(name) {
                const urlParams = new URLSearchParams(window.location.search);
                return urlParams.get(name);
            }
            function decodeBase64(str) {
                return decodeURIComponent(escape(window.atob(str)));
            }

            // On Page Load
            $(document).ready(function () {

                let qParam = getQueryParam("q");
                if (qParam) {
                    let decoded = decodeBase64(qParam); // "Mode=E&Sid=1"
                    let params = {};
                   
                    decoded.split("&").forEach(p => {
                        let [ k, v ] = p.split("=");
                        params[ k ] = v;
                    });

                    if (params[ "Mode" ] === "E" && params[ "Sid" ]) {
                        loadSeries(params[ "Sid" ]);
                        id = params[ "Sid" ];
                        $("#pageTitle").text("Update Series");
                        $("#seriesForm").attr("data-sid", params[ "Sid" ]);
                    }
                }
            });

            // Load existing series
            function setDropdownByText($ddl, text) {
                $ddl.find("option").filter(function () {
                    return $(this).text().toLowerCase() === text.toLowerCase();
                }).prop("selected", true);
            }

            function loadSeries(seriesId) {
                $.ajax({
                    url: "https://localhost:7019/api/Series/Search?seriesId=" + seriesId + "&sortBy=StartDesc",
                    type: "GET",
                    success: function (res) {
                        if (res && res.length > 0) {
                            var series = res[ 0 ];

                            $("#SeriesName").val(series.seriesName);

                            // ✅ Match by text instead of value
                            setDropdownByText($("#SeriesTypeId"), series.seriesType);
                            setDropdownByText($("#SeriesStatusId"), series.seriesStatus);
                            setDropdownByText($("#MatchStatusId"), series.matchStatus);
                            setDropdownByText($("#MatchFormatId"), series.matchFormat);
                            setDropdownByText($("#SeriesMatchTypeId"), series.seriesMatchType);
                            setDropdownByText($("#GenderId"), series.gender);
                            setDropdownByText($("#TrophyTypeId"), series.trophyType);

                            $("#Year").val(series.year);

                            if (series.seriesStartDate)
                                $("#SeriesStartDate").val(series.seriesStartDate.split("T")[ 0 ]);
                            if (series.seriesEndDate)
                                $("#SeriesEndDate").val(series.seriesEndDate.split("T")[ 0 ]);

                            $("#IsActive").val(series.isActive ? "1" : "0");
                            $("#Description").val(series.description);
                        } else {
                            alert("No series data found.");
                        }
                    },
                    error: function (err) {
                        console.error(err);
                        alert("Failed to load series data.");
                    }
                });
            }



            // Save or Update
            function saveSeriesFun() {
                // Collect values from form
                let data = {

                    //SeriesId = id,
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
                var startDate = $("#SeriesStartDate").val();
                var endDate = $("#SeriesEndDate").val();


                if (startDate && endDate && new Date(startDate) > new Date(endDate)) {
                    $('#errorMessage').text('Start date cannot be after end date.')
                      .css({ "color": "red" })
                      .show();
                    return;
                }

                $('#errorMessage').hide();

                $.ajax({
                    url: "https://localhost:7019/api/Series/update/" + id,
                    type: "PUT",
                    contentType: "application/json",
                    data: JSON.stringify(data),
                    success: function (res) {
                        //alert(res.message || "Series saved successfully!");
                        window.location = "ManageSeries.aspx";
                    },
                    error: function (err) {
                       
                        alert("Error: " + (err.responseText || err.statusText));
                    }
                });
                // AJAX POST request
               
            }



           


        </script>
    </body>
</asp:Content>
