using System;
using System.Diagnostics;
using System.Net.Http;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Newtonsoft.Json;
using WebApp.Models;

namespace WebApp.Controllers
{
    public class HomeController : Controller
    {
        WebAppConfiguration Config  { get; }

        public HomeController(WebAppConfiguration config) 
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
            return View(new ErrorViewModel { RequestId = Activity.Current?.Id ?? HttpContext.TraceIdentifier });
        }

        public async Task<IActionResult> GetPing()
        {
            try
            {
                using (var client = new HttpClient())
                {
                    client.BaseAddress = new Uri($"{Config.AiApi.BaseUri}");
                    var response = await client.GetAsync($"/api/ping");
                    response.EnsureSuccessStatusCode();
                    var stringPing = await response.Content.ReadAsStringAsync();
                    var ping = JsonConvert.DeserializeObject<string>(stringPing);
                    return Ok(ping);
                }
            }
            catch (Exception ex)
            {
                return BadRequest($"Error : {ex.Message}");
            }
        }

        public async Task<IActionResult> GetPrediction(PredictionRequest predictionRequest)
        {
            try
            {
                using (var client = new HttpClient())
                {
                    client.BaseAddress = new Uri($"{Config.AiApi.BaseUri}");
                    var response = await client.GetAsync(
                        $"/api/predict" +
                        $"?sex={predictionRequest.Sex}" +
                        $"&age={predictionRequest.Age}" +
                        $"&pclass={predictionRequest.PClass}" +
                        $"&fare={predictionRequest.Fare}" +
                        $"&sibsp={predictionRequest.SibSp}" +
                        $"&parch={predictionRequest.Parch}");
                    response.EnsureSuccessStatusCode();
                    var stringPrediction = await response.Content.ReadAsStringAsync();
                    var prediction = JsonConvert.DeserializeObject<Prediction>(stringPrediction);
                    return Ok(prediction);
                }
            }
            catch (Exception ex)
            {
                return BadRequest($"Error : {ex.Message}");
            }
        }
    }
}