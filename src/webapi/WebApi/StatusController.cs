using Microsoft.AspNetCore.Mvc;

namespace WebApi;

[Route("api/[controller]")]
[ApiController]
public class StatusController : ControllerBase
{
    [HttpGet]
    public string GetStatus()
    {
        return "WebApi OK";
    }
}