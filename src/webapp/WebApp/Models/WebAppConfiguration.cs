namespace WebApp.Models
{
    public class WebAppConfiguration
    {
        public string ApplicationName { get; set; } = string.Empty;

        public AiApiConfiguration AiApi { get; set; } = new AiApiConfiguration();
    }

    public class AiApiConfiguration
    {
        public string BaseUri { get; set; } = string.Empty;
    }
}