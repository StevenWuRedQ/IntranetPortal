using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Http;
using RedQ.UnderwritingService.Models.NewYork;
using RedQ.UnderwritingService.Services;

namespace RedQ.UnderwritingService.Controllers
{
    public class UnderwritingServiceController : ApiController
    {
        /// <summary>
        /// Post a single Job for process
        /// </summary>
        /// <param name="singleRequest"></param>
        /// <param name="isSave"></param>
        /// <returns></returns>
        [Route("api/x"), HttpPost]
        public UnderwritingOutput PostSingleJob([FromBody] UnderwritingInput input)
        {
            var output = UnderwritingService.Services.UnderwritingService.ApplyRule(input);
            return output;
        }

        /// <summary>
        /// Post a batch job for process
        /// </summary>
        /// <param name="batchRequest"></param>
        /// <returns></returns>
//        [Route("api/underwritingservice/batch")]
//        public IHttpActionResult PostBatchJobs()
//        {
//           return Ok();
//        }


        [Route("api/underwriting"), HttpPost]
        public IHttpActionResult PostUnderwriting([FromBody()] Underwriting uw)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }
            var u = UnderwritingDAO.SaveOrUpdate(uw, HttpContext.Current.User.Identity.Name);
            return Ok(u);
        }

        [Route("api/underwriting/archive"), HttpPost]
        public IHttpActionResult PostArchive([FromBody()] object[] data)
        {
            dynamic underwriting = (Underwriting)data[0];
            dynamic archiveNote = Convert.ToString(data[1]);
            dynamic currentUser = HttpContext.Current.User.Identity.Name;
            UnderwritingDAO.SaveOrUpdate(underwriting, currentUser);
            dynamic isSaved = UnderwritingDAO.Archive(underwriting.BBLE, currentUser, archiveNote);
            if (isSaved)
            {
                return Ok();
            }
            else
            {
                return BadRequest();
            }
        }

        [Route("api/underwriting/archived/{bble}"), HttpGet]
        public IHttpActionResult GetArchivedListByBBLE(string bble)
        {
            return Ok(UnderwritingDAO.LoadArchivedList(bble).AsEnumerable());
        }

        [Route("api/underwriting/archived/id/{id}"), HttpGet]
        public IHttpActionResult GetArchivedByID(int id)
        {
            return Ok(UnderwritingDAO.GetArchived(id));
        }

        [Route("api/underwriting/{bble}"), HttpGet]
        public IHttpActionResult GetUnderwritingByBBLE(string bble)
        {
            var uw = UnderwritingDAO.GetUnderwritingByBBLE(bble);
            return Ok(uw);
        }
    }






}
