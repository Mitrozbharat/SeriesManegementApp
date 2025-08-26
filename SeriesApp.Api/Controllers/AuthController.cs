using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using SeriesApp.BLL.Interfaces;
using SeriesApp.BLL.Services;
using SeriesApp.Domain.DTOs;
using SeriesApp.Domain.Entities;
using System;
using System.Threading.Tasks;

namespace SeriesApp.Api.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class AuthController : ControllerBase
    {
        private readonly IAuthService _authService;
        public AuthController( IAuthService authService)
        {

            this._authService = authService;        
        }

        [HttpPost("login")]
        public async Task<IActionResult> Login([FromBody]UserDto user)
        {
            if (user == null)
                return BadRequest("User data is required");


            bool isValid = await _authService.Login(user);

            if (!isValid)
              
              return NotFound("Invalid username or password");

            return Ok("Login Success");
        }

     
        [HttpPost("register")]
        public async Task<IActionResult> register(RegisterDto dto)
        {
            if (!ModelState.IsValid)
                return BadRequest(ModelState);

             bool isValid = await _authService.Register(dto);

            if (!isValid)

                return BadRequest("Registration Failed");

            return Ok("Registration Success");
        }

        [HttpGet]
        public IActionResult Logout()
        {
           
            return RedirectToAction("Index");
        }


    }
}
