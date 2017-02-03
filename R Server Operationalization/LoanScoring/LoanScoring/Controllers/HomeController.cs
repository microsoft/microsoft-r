using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using LoanScoring.Models;
using TechReady;
using TechReady.Models;
using System.Configuration;

namespace LoanScoring.Controllers
{
    public class HomeController : Controller
    {
        public ActionResult Index()
        {
            return View();
        }

        [HttpPost]
        public ActionResult Index(LoanDetailModel loanDetail)
        {
            if (ModelState.IsValid)
            {
                var client = GetAuthenticatedClient();
                var inputs = GetInputParameter(loanDetail);
                var results = client.LoanPredictService(inputs);
                double? loanScore = null;
                if (results != null)
                {
                    loanScore = results.OutputParameters.LoanScore;
                }
                ViewBag.loanprediction = WillLoanPayOff(loanScore);
                return View();
            }
            else
                return View(loanDetail);
        }

        private string WillLoanPayOff(double? loanScore)
        {
            var output = "Bad Loan - Potential Charge-off.";
            if (loanScore.HasValue)
            {
                if (loanScore.HasValue
                    && loanScore.Value < Convert.ToDouble(ConfigurationManager.AppSettings["LoanScoreCutOff"]))
                {
                    output = "Good Loan - No Charge-off risk.";
                }
            }
            else
                output = "Loan Service can't compute the risk.";
            return output;
        }

        private InputParameters GetInputParameter(LoanDetailModel loanDetail)
        {
            InputParameters inputs = new InputParameters()
            {
                RevolUtil = loanDetail.revolUtil,
                AllUtil = loanDetail.allUtil,
                AnnualIncJoint = loanDetail.annualIncJoint,
                DtiJoint = loanDetail.dtiJoin,
                IntRate = loanDetail.intRate,
                LoanAmnt = loanDetail.loanAmnt,
                MthsSinceLastRecord = loanDetail.mthsSinceLastRecod,
                TotalRecPrncp = loanDetail.totalRecPrncp
            };
            return inputs;
        }

        private InputParameters GetDummyInput(LoanDetailModel loanDetail)
        {
            InputParameters inputs = new InputParameters()
            {
                RevolUtil = 1,
                AllUtil = 1,
                AnnualIncJoint = 1,
                DtiJoint = 1,
                IntRate = 1,
                MthsSinceLastRecord = 3,
                TotalRecPrncp = 5
            };
            return inputs;
        }

        private LoanPredictService1484942117 GetAuthenticatedClient()
        {
            var client = new LoanPredictService1484942117(new Uri(ConfigurationManager.AppSettings["WebNodeAddress"]));

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

        public ActionResult Contact()
        {
            ViewBag.Message = "Puget Sound Bank - Contact Information.";
            return View();
        }

        private void test()
        {
        }
    }
}