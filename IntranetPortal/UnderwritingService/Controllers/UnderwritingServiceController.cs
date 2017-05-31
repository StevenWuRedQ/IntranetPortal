using RedQ.UnderwritingService.Models.NewYork;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Http;
using System.Web.Http.Cors;

namespace RedQ.UnderwritingService.Controllers
{
    [EnableCors(origins: "*", headers: "*", methods: "*")]
    public class UnderwritingServiceController: ApiController
    {

        [Route("api/underwritingservice/calculate"), HttpPost]
        public UnderwritingOutput PostSingleJob([FromBody]UnderwritingInput input)
        {
            return UnderwritingService.Services.UnderwritingService.ApplyRule(input);
        }

    }
}