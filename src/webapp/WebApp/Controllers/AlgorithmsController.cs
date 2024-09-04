using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Net.Http;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Newtonsoft.Json;
using WebApp.Models;

namespace WebApp.Controllers
{
    public class AlgorithmsController : Controller
    {
        WebAppConfiguration Config { get; }

        public AlgorithmsController(WebAppConfiguration config)
        {
            Config = config;
        }

        public IActionResult Index()
        {
            ViewData["ApplicationName"] = Config.ApplicationName;
            return View();
        }

        public IActionResult Error()
        {
            return View(new ErrorViewModel {RequestId = Activity.Current?.Id ?? HttpContext.TraceIdentifier});
        }

        public async Task<IActionResult> GetStats()
        {
            try
            {
                using (var client = new HttpClient())
                {
                    client.BaseAddress = new Uri($"{Config.AiApi.BaseUri}");
                    var response = await client.GetAsync($"/api/stats");
                    response.EnsureSuccessStatusCode();
                    var stringStats = await response.Content.ReadAsStringAsync();
                    var stats = JsonConvert.DeserializeObject<IEnumerable<Stats>>(stringStats);
                    return Ok(stats);
                }
            }
            catch (Exception ex)
            {
                return BadRequest($"Error : {ex.Message}");
            }
        }
    }
}