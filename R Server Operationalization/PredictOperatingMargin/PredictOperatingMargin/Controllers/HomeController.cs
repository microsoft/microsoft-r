using System;
using System.Web.Mvc;
using PredictOperatingMargin.Models;
using HotelOperatingMargin;
using HotelOperatingMargin.Models;
using System.Configuration;

namespace PredictOperatingMargin.Controllers
{
    public class HomeController : Controller
    {
        public ActionResult Index()
        {
            return View();
        }
        [HttpPost]
        public ActionResult Index(HotelOperatingModel operatingModel)
        {
            if (ModelState.IsValid)
            {
                var client = GetAuthenticatedClient();
                var inputs = GetInputParameter(operatingModel);
                var results = client.CheckOperatingMargin(inputs);
                double? score = null;
                if (results != null)
                {
                    score = results.OutputParameters.Margin;
                }
                ViewBag.operatingmarginlevel = IsMarginGood(score);
                return View();
            }
            else
                return View(operatingModel);
        }

        private string IsMarginGood(double? score)
        {
            var output = "Margin not good for hotel expansion:" + score.ToString();
            if (score.HasValue)
            {
                if (score.HasValue
                    && score.Value > Convert.ToDouble(ConfigurationManager.AppSettings["MarginCutOff"]))
                {
                    output = "Good Margin for hotel expansion:" + score.ToString();
                }
            }
            else
                output = "Loan Service can't compute the risk.";
            return output;
        }

        private CheckLocationViabilityForHotel GetAuthenticatedClient()
        {
            var client = new CheckLocationViabilityForHotel(new Uri(ConfigurationManager.AppSettings["WebNodeAddress"]));
            var loginRequest = new LoginRequest(
                ConfigurationManager.AppSettings["WebNodeUserName"],
                ConfigurationManager.AppSettings["WebNodePassword"]
                );
            var loginResponse = client.Login(loginRequest);
            var headers = client.HttpClient.DefaultRequestHeaders;
            var accessToken = loginResponse.AccessToken;
            headers.Remove("Authorization");
            headers.Add("Authorization", $"Bearer {accessToken}");
            return client;
        }

        private InputParameters GetInputParameter(HotelOperatingModel operatingModel)
        {
            InputParameters inputs = new InputParameters()
            {
                TotalRooms = operatingModel.numberOfRooms,
                AnnualVisitors = operatingModel.cityAnnualVisitor,
                MedianIncome = operatingModel.cityMedianIncome,
                NearestCompetition = operatingModel.nearestCompetition
            };
            return inputs;
        }

        public ActionResult About()
        {
            ViewBag.Message = "Your application description page.";

            return View();
        }

        public ActionResult Contact()
        {
            ViewBag.Message = "Your contact page.";

            return View();
        }
    }
}