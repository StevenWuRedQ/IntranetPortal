using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using RedQ.UnderwritingService.Models.NewYork;

namespace RedQ.UnderwritingService.Hub
{
    public class UnderwritingServiceHub : Microsoft.AspNet.SignalR.Hub
    {
        public UnderwritingOutput PostSingleJob(UnderwritingInput input)
        {
            return UnderwritingService.Services.UnderwritingService.ApplyRule(input);
        }
        
        public Underwriting PostUnderwriting(Underwriting underwriting, string username)
        {
            return UnderwritingDAO.SaveOrUpdate(underwriting, username);
        }

        public UnderwritingArchived PostArchive(Underwriting underwriting, string archiveNote, string username)
        {
            UnderwritingDAO.SaveOrUpdate(underwriting, username);
            return UnderwritingDAO.Archive(underwriting.BBLE, username, archiveNote);
           
        }

        public IEnumerable<UnderwritingArchived> GetArchivedListByBBLE(string bble)
        {
            return UnderwritingDAO.LoadArchivedList(bble).AsEnumerable();
        }

        public UnderwritingArchived GetArchivedByID(int id)
        {
            return UnderwritingDAO.GetArchived(id);
        }

        public Underwriting GetUnderwritingByBBLE(string bble)
        {
            return UnderwritingDAO.GetUnderwritingByBBLE(bble);
        }

        public string[] GetUnderwritingBBLEs()
        {
            return UnderwritingDAO.GetAllUnderwritingBBLE();
        }

        public object[] GetUnderwritingListInfo()
        {
            return UnderwritingDAO.GetUnderwritingListInfo();
        }
    }
}