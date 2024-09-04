using System.Diagnostics;
using Microsoft.AspNetCore.Mvc;
using WebApp.Models;

namespace WebApp.Controllers
{
    public class AboutController : Controller
    {
        WebAppConfiguration Config { get; }

        public AboutController(WebAppConfiguration config)
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
    }
}