using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using RedQ.UnderwritingService.Models.NewYork;
using IntranetPortal.Data;
using RedQ.UnderwritingService.Services;

namespace RedQ.UnderwritingService.Hub
{
    public class UnderwritingServiceHub : Microsoft.AspNet.SignalR.Hub
    {
        public UnderwritingOutput PostSingleJob(UnderwritingInput input)
        {
            return UnderwritingService.Services.UnderwritingService.ApplyRule(input);
        }

        public Context DebugRule(UnderwritingInput input) {
            return UnderwritingService.Services.UnderwritingService.DebugRule(input);

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

        public object[] GetUnderwritingListInfoByStatus(int status)
        {
            return UnderwritingDAO.GetUnderwritingListInfoByStatus(status);
        }

        public void ChangeStatus(string BBLE, int status, string statusNote, string updateBy)
        {
            if (string.IsNullOrEmpty(BBLE)) throw new Exception("BBLE is Required.");
            if (string.IsNullOrEmpty(statusNote)) throw new Exception("Status Note is Required.");
            if (string.IsNullOrEmpty(updateBy)) throw new Exception("Underwriter's infomation is missing.");
            Underwriting.UnderwritingStatusEnum estatus = (Underwriting.UnderwritingStatusEnum)status;
            UnderwritingDAO.ChangeStatus(BBLE, estatus, statusNote, updateBy);
            return;
        }

        public Underwriting TryCreate(Underwriting underwriting)
        {
            if (underwriting == null) return null;
            var uw = UnderwritingDAO.TryCreate(underwriting);
            return uw;
        }


        public AuditLog[] GetAuditLogs(String objectName , String recordId )
        {
            return UnderwritingDAO.GetAuditLogs(objectName, recordId);
        }
    }
}