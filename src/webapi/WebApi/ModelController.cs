using Microsoft.AspNetCore.Mvc;

namespace WebApi;

[Route("api/[controller]")]
[ApiController]
public class ModelController : ControllerBase
{
    private readonly IConfiguration _config;

    public ModelController(IConfiguration config)
    {
        _config = config;
    }

    [HttpGet]
    public async Task<string> GetModel()
    {
        HttpClient httpClient = new()
        {
            BaseAddress = new Uri(_config.GetValue<string>("WebApi:RApiUrl")!)
        };

        using var response = await httpClient.GetAsync("api/ping");

        response.EnsureSuccessStatusCode();
        
        return await response.Content.ReadAsStringAsync();
    }
}