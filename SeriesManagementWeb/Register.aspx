<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Register.aspx.cs" Inherits="SeriesManagementWeb.Register"  MasterPageFile="~/Site.Master"  %>

<asp:Content ID="bodycontent" ContentPlaceHolderID="maincontent" runat="server">

    <style>
        .login-box {
            /* background: #fff; */
            padding: 15px 20px;
            border-radius: 10px;
            box-shadow: 0 4px 8px rgba(0,0,0,0.1);
            width: 600px;
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
        <div class="d-flex justify-content-center align-content-center" style="margin: 80px 0px">
            <div class="login-box">

                <h2> Registration  <span id="succees"></span></h2>

                <div id="loginForm">
                   
                        <div class="row">
                            <div class="col-md-6 col-lg-6">
                                <div class="form-group mb-2">
                                    <label asp-for="Name"></label>
                                    <input asp-for="Name" id="Name" class="form-control" placeholder="Enter Name" />
                                    <span asp-validation-for="Name" class="text-danger"></span>
                                </div>
                            </div>
                            <div class="col-md-6 col-lg-6">
                                <div class="form-group mb-2">
                                    <label asp-for="Email"></label>
                                    <input asp-for="Email" id="Email" placeholder="Enter Email" class="form-control" />
                                    <span asp-validation-for="Email" class="text-danger"></span>
                                </div>
                            </div>

                            <div class="col-md-6 col-lg-6">
                                <div class="form-group mb-2">
                                    <label asp-for="Username"></label>
                                    <input asp-for="Username" id="Username" class="form-control" placeholder="Enter Username" />
                                    <span asp-validation-for="Username" id="error" class="text-danger"></span>
                                </div>
                            </div>
                            <div class="col-md-6 col-lg-6">
                                <div class="form-group mb-2">
                                    <label asp-for="Password"></label>
                                    <input asp-for="Password" id="Password" class="form-control" placeholder="Enter Password" />
                                    <span asp-validation-for="Password" class="text-danger"></span>
                                </div>


                            </div>
                  
                    <button type="button" id="btnsubmit" class="btn btn-primary w-100 mt-2">Sign Up</button>
                </div>

            </div>
                   <p class="mt-4 mt-lg-3"><a href="Default.aspx" class="text-primary mt-4"> Are you Alredy Registed ?  Login </a> </p>

          
        </div>

    </section>  
    
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdn.datatables.net/1.10.24/js/jquery.dataTables.min.js"></script>
    <script src="https://cdn.datatables.net/1.10.24/js/dataTables.bootstrap4.min.js"></script>

<script>

    // Handle login button click
    $("#btnsubmit").on("click", function ()
    {

        let name = document.querySelector("#Name").value;
        let email = document.querySelector("#Email").value;
        let username = document.querySelector("#Username").value;
        let password = document.querySelector("#Password").value;


        if (!username) {
            $("#error").removeClass("d-none").text("Username required.");
            return;
        }

        if (!password) {
            $("#error").removeClass("d-none").text("password required.");
            return;
        }

        if (!Email) {
            $("#error").removeClass("d-none").text("Email required.");
            return;
        }

        if (!Name) {
            $("#error").removeClass("d-none").text("Name required.");
            return;
        }

        console.log(username, password);

        $.ajax({
            url: "https://localhost:7019/api/Auth/register", 
            type: "POST",
            contentType: "application/json",
            data: JSON.stringify({
                Name: name,
                Email: email,
                Username: username,
                Password: password,
               

            }),
            success: function (response, textStatus, xhr) {

                console.log("✅ Success:", response);

                if (xhr.status === 200) {
                    //alert(response.message || "Login successful!");
                    alert("Register success");
                    
                   window.location.href = "Default.aspx";
                  
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

  
</script>

</asp:Content>
