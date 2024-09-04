using System.Collections.Generic;
using Newtonsoft.Json;

namespace WebApp.Models
{
    public class Prediction
    {
        public Survived Survived { get; set; }

        public Confidence Confidence { get; set; }

        public IEnumerable<IEnumerable<Model>> Models { get; set; }
    }

    public class Survived
    {
        public IEnumerable<string> Result { get; set; }

        public IEnumerable<double> Confidence { get; set; }
    }

    public class Confidence
    {
        public IEnumerable<double> Survived { get; set; }

        public IEnumerable<double> Perished { get; set; }
    }

    public class Model
    {
        public int Type { get; set; }

        public string Prediction { get; set; }

        [JsonProperty(PropertyName = "probability.final")]
        public double ProbabilityFinal { get; set; }

        [JsonProperty(PropertyName = "probability.survived")]
        public double ProbabilitySurvived { get; set; }

        [JsonProperty(PropertyName = "probability.perished")]
        public double ProbabilityPerished { get; set; }

        public double Sensitivity { get; set; }

        public double Specificity { get; set; }

        public double F1 { get; set; }

        public double Kappa { get; set; }
    }
}