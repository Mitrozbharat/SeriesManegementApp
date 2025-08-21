<%@ Page Title="Home Page" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="SeriesManagementWeb._Default" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">

  <style>
    .login-box {
      background: #fff;
      padding: 20px 25px;
      border-radius: 10px;
      box-shadow: 0 4px 8px rgba(0,0,0,0.1);
      width: 300px;
      text-align: center;
    }
    .login-box h2 {
      margin-bottom: 20px;
      color: #333;
    }
    .login-box input {
      width: 100%;
      padding: 10px;
      margin: 8px 0;
      border: 1px solid #ccc;
      border-radius: 6px;
      outline: none;
    }
    .login-box button {
      width: 100%;
      padding: 10px;
      background: #007bff;
      color: white;
      border: none;
      border-radius: 6px;
      cursor: pointer;
      font-size: 16px;
    }
    .login-box button:hover {
      background: #0056b3;
    }
    .error {
      display: none;
      color: red;
      font-size: 0.9rem;
      margin: 5px 0;
    }
    .footer {
      margin-top: 15px;
      font-size: 0.8rem;
      color: #666;
    }
  </style>

<section class="container">
  <div class="d-flex justify-content-center align-content-center">
    <div class="login-box">

      <h2>Login <span id="succees">  </span></h2>
      <!-- Removed form tag to prevent reload -->
      <div id="loginForm">
        <input type="text" id="username" placeholder="Username" required>
        <input type="password" id="password" placeholder="Password" required>
        <p class="error text-danger d-none" id="error">Invalid username or password.</p>
        <button type="button" id="btnsubmit" class="btn btn-primary w-100 mt-2">Sign In</button>
      </div>

      <p class="footer">© <span id="year"></span> My Website</p>
        <p>Username: bharat</p>
        <p>Password: Pass@123</p>
    </div>
  </div>

  <!-- Navigation links (hidden until login success) -->
  <div id="navLinks" class="text-center mt-3 d-none">
    <a href="ManageSeries" class="btn btn-outline-primary m-1">ManageSeries</a>
    <a href="AddSeries" class="btn btn-outline-primary m-1">AddSeries</a>
    <a href="SeriesReport" class="btn btn-outline-primary m-1">Report</a>
    <a href="#" class="btn btn-outline-primary m-1" id="logoutBtn">Logout</a>
  </div>
</section>
        <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdn.datatables.net/1.10.24/js/jquery.dataTables.min.js"></script>
    <script src="https://cdn.datatables.net/1.10.24/js/dataTables.bootstrap4.min.js"></script>

<script>
    // Show current year
    document.getElementById("year").textContent = new Date().getFullYear();

    // Handle login button click
    $("#btnsubmit").on("click", function ()
    {
       
        let username = $("#username").val().trim();
        let password = $("#password").val().trim();

        if (!username || !password) {
            $("#error").removeClass("d-none").text("Username and password required.");
            return;
        }

        console.log(username, password);

        $.ajax({
            url: "https://localhost:7019/api/Auth/Login", // backend API
            type: "POST",
            contentType: "application/json",
            data: JSON.stringify({ username: username, password: password }),
            success: function (response)
            {
                console.log("Login successful:", response);

                // Hide login & show nav links
                $("#loginForm").hide();
                $("#error").hide();
                $("#navLinks").removeClass("d-none");

                //window.location.href = "ManageSeries";

               
            },
            error: function () {
                $("#error").removeClass("d-none").text("Login failed! Please try again.");
            }
        });
    });

    // Handle logout
    $("#logoutBtn").on("click", function () {
        $("#navLinks").addClass("d-none");
        $("#loginForm").show();
        $("#username").val("");
        $("#password").val("");
    });
</script>

</asp:Content>
