namespace WebApp.Models
{
    public class PredictionRequest
    {
        public string Sex { get; set; }

        public int Age { get; set; }
        
        public int PClass { get; set; }
        
        public double Fare { get; set; }
       
        public int SibSp { get; set; }
        
        public int Parch { get; set; }
    }
}