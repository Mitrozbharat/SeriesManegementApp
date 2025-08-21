using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using SeriesApp.BLL.Interfaces;
using SeriesApp.BLL.Services;
using SeriesApp.Domain.DTOs;
using SeriesApp.Domain.Entities;

namespace SeriesApp.Api.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class AuthController : ControllerBase
    {
        private readonly ILoginService loginService;
        public AuthController(ILoginService loginService)
        {

            this.loginService = loginService;
        }

        [HttpPost("Login")]
        public async Task<IActionResult> Login([FromBody]UserDto user)
        {
            if (user == null)
                return BadRequest("User data is required");


            bool isValid = await loginService.Login(user);

            if (!isValid)
                return NotFound("Invalid username or password");

            return Ok("Login Success");
        }

    }
}
