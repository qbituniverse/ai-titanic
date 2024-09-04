using System.Collections.Generic;
using Newtonsoft.Json;

namespace WebApp.Models
{
    public class Stats
    {
        public IEnumerable<int> Type { get; set; }

        public IEnumerable<Summary> Summary { get; set; }
    }

    public class Summary
    {
        public double Sensitivity { get; set; }

        public double Specificity { get; set; }

        public double Precision { get; set; }

        public double Recall { get; set; }

        public double F1 { get; set; }

        [JsonProperty(PropertyName = "kappa_weighted")]
        public double KappaWeighted { get; set; }

        [JsonProperty(PropertyName = "kappa_unweighted")]
        public double KappaUnweighted { get; set; }

        [JsonProperty(PropertyName = "balanced_accuracy")]
        public double BalancedAccuracy { get; set; }

        public double Accuracy { get; set; }

        [JsonProperty(PropertyName = "error_rate")]
        public double ErrorRate { get; set; }
    }
}