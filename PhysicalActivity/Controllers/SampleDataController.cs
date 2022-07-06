using System.Collections.Generic;
using Microsoft.AspNetCore.Mvc;

namespace PhysicalActivity.Controllers
{
    [Route("api/[controller]")]
    public class SampleDataController : Controller
    {
        private static string[] DailyLog = new[]
        {
            // Sample fitbit data
            // Source: https://www.kaggle.com/datasets/arashnic/fitbit
            "1503960366,4/12/2016,1985",
            "1503960366,4/13/2016,1797",
            "1503960366,4/14/2016,1776",
            "1503960366,4/15/2016,1745",
            "1503960366,4/16/2016,1863",
            "1503960366,4/17/2016,1728",
            "1503960366,4/18/2016,1921",
            "1503960366,4/19/2016,2035",
            "1503960366,4/20/2016,1786",
            "1503960366,4/21/2016,1775",
            "1503960366,4/22/2016,1827",
            "1503960366,4/23/2016,1949",
            "1503960366,4/24/2016,1788",
            "1503960366,4/25/2016,2013",
            "1503960366,4/26/2016,1970",
            "1503960366,4/27/2016,2159",
            "1503960366,4/28/2016,1898",
            "1503960366,4/29/2016,1837",
            "1503960366,4/30/2016,1947",

        };

        [HttpGet(nameof(Daily))]
        public IEnumerable<Calorie> Daily()
        {
            var calories = new List<Calorie>();

            foreach (var feed in DailyLog)
            {
                var rawFeed = feed.Split(',');
                calories.Add(new Calorie
                {
                    Id = int.Parse(rawFeed[0]),
                    DateFormatted = rawFeed[1],
                    Count = int.Parse(rawFeed[2])
                });
            }

            return calories;
        }

        public class Calorie
        {
            public string DateFormatted { get; set; }
            public int Id { get; set; }
            public int Count { get; set; }
        }
    }
}
