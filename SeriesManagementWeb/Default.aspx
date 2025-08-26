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
  <div class="d-flex justify-content-center align-content-center" style="margin:150px 0px">
    <div class="login-box">

      <h2>Login <span id="succees">  </span></h2>
    
      <div id="loginForm">
        <input class="form-control " type="text" id="username" placeholder="Username" required>
        <input class="form-control" type="password" id="password" placeholder="Password" required>
        <p class="error text-danger d-none" id="error">Invalid username or password.</p>
        <button type="button" id="btnsubmit" class="btn btn-primary w-100 mt-2">Sign In</button>

          <p class="error" id="error-id"> Please check the username or password ?</p>

           <p class="mt-4 mt-lg-3"><a href="Register.aspx" class="text-primary mt-4">Are you Registed ? Register </a></p>

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

    document.querySelector('#error-id').style.display = "none";

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
            url: "https://localhost:7019/api/Auth/Login", 
            type: "POST",
            contentType: "application/json",
            data: JSON.stringify({
                username: $("#username").val(), 
                password: $("#password").val()
            }),
            success: function (response, textStatus, xhr) {
                console.log("✅ Success:", response);

                if (xhr.status === 200) {
                    //alert(response.message || "Login successful!");
                 
                    window.location.href = "ManageSeries.aspx";
                }
            },
            error: function (xhr, textStatus, errorThrown) {
                let message = " An unexpected error occurred.";

                switch (xhr.status) {
                    case 400:
                        message = xhr.responseJSON?.message || "Bad request: missing or invalid data.";
                        break;
                    case 401:
                        message = xhr.responseJSON?.message || "Unauthorized: Invalid username or password.";
                        break;
                    case 404:
                        message = xhr.responseJSON?.message || "API not found.";
                        document.querySelector('#error-id').style.display = "block";

                        break;
                    case 500:
                        message = "Server error. Please try again later.";
                        break;
                    default:
                        message = xhr.responseJSON?.message || `Error ${xhr.status}: ${xhr.statusText}`;
                }

                console.error("⚠️ AJAX Error:", message);
                //alert(message);

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
