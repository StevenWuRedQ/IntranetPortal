using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.InteropServices;
using IntranetPortal.Core;
using IntranetPortal.Data;
using RedQ.UnderwritingService.Models.NewYork;

public class UnderwritingDAO
{
    public static Underwriting GetUnderwritingByBBLE(string bble)
    {
        using (UnderwritingEntity ctx = new UnderwritingEntity())
        {
            dynamic uw = ctx.Underwritings.FirstOrDefault(underwriting => underwriting.BBLE == bble);
            if (null != uw)
            {
                foreach (var prop in EntityHelper<Underwriting>.GetNavigationProperties(ctx))
                {
                    ctx.Entry(uw).Reference(prop.ToString()).Load();
                }
            }
            return uw;
        }
    }

    public static Underwriting TryCreate(Underwriting underwriting)
    {
        using (UnderwritingEntity ctx = new UnderwritingEntity())
        {
            if (string.IsNullOrEmpty(underwriting.BBLE)) throw new Exception("Cannot create new underwriting without BBLE.");
            var uw = ctx.Underwritings.FirstOrDefault(u => u.BBLE.Trim() == underwriting.BBLE.Trim());
            if (uw != null) return null;
            underwriting.UpdateBy = "System";
            underwriting.UpdateDate = DateTime.Now;
            ctx.Underwritings.Add(underwriting);
            try
            {
                ctx.SaveChanges();
            }
            catch (Exception e) {
                throw e;
            }
            return underwriting;
        }
    }

    public static Underwriting Create(string BBLE, string createby)
    {
        using (UnderwritingEntity ctx = new UnderwritingEntity())
        {
            if (string.IsNullOrEmpty(BBLE)) throw new Exception("BBLE cannot be empty.");
            if (string.IsNullOrEmpty(createby)) throw new Exception("Creator cannot be empty");

            var underwriting = ctx.Underwritings.FirstOrDefault(u => u.BBLE == BBLE);
            if (underwriting != null) return underwriting;
            underwriting = new Underwriting();
            underwriting.BBLE = BBLE;
            underwriting.CreateBy = createby;
            underwriting.CreateDate = DateTime.Now;

            underwriting.PropertyInfo = new UnderwritingPropertyInfo();
            underwriting.DealCosts = new UnderwritingDealCosts();
            underwriting.RehabInfo = new UnderwritingRehabInfo();
            underwriting.RentalInfo = new UnderwritingRentalInfo();
            underwriting.LienInfo = new UnderwritingLienInfo();
            underwriting.LienCosts = new UnderwritingLienCosts();

            underwriting.CashScenario = new UnderwritingCashScenario();
            underwriting.LoanScenario = new UnderwritingLoanScenario();
            underwriting.FlipScenario = new UnderwritingFlipScenario();
            underwriting.MinimumBaselineScenario = new UnderwritingMinimumBaselineScenario();
            underwriting.BestCaseScenario = new UnderwritingBestCaseScenario();
            underwriting.RentalInfo = new UnderwritingRentalInfo();
            underwriting.Summary = new UnderwritingSummary();

            underwriting.Status = Underwriting.UnderwritingStatusEnum.NewCreated;

            ctx.Underwritings.Add(underwriting);
            ctx.SaveChanges(createby);
            return underwriting;
        }
    }

    public static Underwriting SaveOrUpdate(Underwriting uw, string saveby)
    {
        if (String.IsNullOrEmpty(uw.BBLE))
        {
            throw new Exception("BBLE cannot be empty");
        }
        using (UnderwritingEntity ctx = new UnderwritingEntity())
        {
            var u = ctx.Underwritings.SingleOrDefault(t => t.BBLE == uw.BBLE);
            if (u != null)
            {
                if ((int)uw.Status <= 2) uw.Status = Underwriting.UnderwritingStatusEnum.Processing;
                uw.UpdateBy = saveby;
                uw.UpdateDate = DateTime.Now;
                ctx.Entry(u).CurrentValues.SetValues(uw);
                EntityHelper<Underwriting>.ReferenceUpdate(ctx, u, uw);
            }
            else
            {
                uw.CreateBy = saveby;
                uw.CreateDate = DateTime.Now;
                uw.Status = Underwriting.UnderwritingStatusEnum.NewCreated;
                ctx.Underwritings.Add(uw);
            }
            ctx.SaveChanges(saveby);

            return u;
        }
    }

    public static AuditLog[] GetAuditLogs(String objName, String recordId)
    {
        using (var ctx = new UnderwritingEntity())
        {
            return ctx.AuditLogs.Where((l) => l.TableName == objName && l.RecordId == recordId).ToArray();
        }
    }

    public static UnderwritingArchived GetArchived(int id)
    {
        using (UnderwritingEntity ctx = new UnderwritingEntity())
        {
            var archived = ctx.UnderwritingArchived.FirstOrDefault(ad => ad.Id == id);
            if (archived != null)
            {
                foreach (var prop in EntityHelper<UnderwritingArchived>.GetNavigationProperties(ctx))
                {
                    ctx.Entry(archived).Reference(prop.ToString()).Load();
                }
            }
            return archived;
        }
    }

    public static UnderwritingArchived Archive(string bble, string saveBy, string note)
    {
        using (UnderwritingEntity ctx = new UnderwritingEntity())
        {
            Underwriting underwriting = GetUnderwritingByBBLE(bble);
            UnderwritingArchived archived = new UnderwritingArchived();
            if (underwriting != null)
            {

                archived.BBLE = underwriting.BBLE;
                archived.ArchivedBy = saveBy;
                archived.ArchivedDate = DateTime.Now;
                archived.ArchivedNote = note;

                archived.PropertyInfo = underwriting.PropertyInfo;
                archived.DealCosts = underwriting.DealCosts;
                archived.RehabInfo = underwriting.RehabInfo;
                archived.RentalInfo = underwriting.RentalInfo;
                archived.LienInfo = underwriting.LienInfo;
                archived.LienCosts = underwriting.LienCosts;

                archived.CashScenario = underwriting.CashScenario;
                archived.LoanScenario = underwriting.LoanScenario;
                archived.FlipScenario = underwriting.FlipScenario;
                archived.MinimumBaselineScenario = underwriting.MinimumBaselineScenario;
                archived.BestCaseScenario = underwriting.BestCaseScenario;
                archived.RentalInfo = underwriting.RentalInfo;
                archived.Summary = underwriting.Summary;

                archived.PropertyInfo.Id = 0;
                archived.DealCosts.Id = 0;
                archived.RehabInfo.Id = 0;
                archived.RentalInfo.Id = 0;
                archived.LienInfo.Id = 0;
                archived.LienCosts.Id = 0;

                archived.CashScenario.Id = 0;
                archived.LoanScenario.Id = 0;
                archived.FlipScenario.Id = 0;
                archived.MinimumBaselineScenario.Id = 0;
                archived.BestCaseScenario.Id = 0;
                archived.RentalInfo.Id = 0;
                archived.Summary.Id = 0;

                ctx.UnderwritingArchived.Add(archived);
                ctx.SaveChanges(saveBy);
            }
            return archived;
        }
    }

    public static UnderwritingArchived[] LoadArchivedList(string BBLE)
    {
        using (UnderwritingEntity ctx = new UnderwritingEntity())
        {
            var list = from archived in ctx.UnderwritingArchived
                       where archived.BBLE == BBLE
                       select archived;
            return list.ToArray();
        }
    }

    public static string[] GetAllUnderwritingBBLE()
    {
        using (var ctx = new UnderwritingEntity())
        {
            var bbles = from underwriting in ctx.Underwritings
                        select underwriting.BBLE;
            return bbles.ToArray();
        }
    }

    public static object[] GetUnderwritingListInfo()
    {
        using (var ctx = new UnderwritingEntity())
        {
            var underwritings = from underwriting in ctx.Underwritings
                                select new
                                {
                                    BBLE = underwriting.BBLE,
                                    UnderwritingStatus = underwriting.Status,
                                    UnderwritingCreateBy = underwriting.CreateBy,
                                    UnderwritingCreateDate = underwriting.CreateDate,
                                    UnderwritingUpdateDate = underwriting.UpdateDate
                                };
            return underwritings.ToArray();
        }
    }

    public static object[] GetUnderwritingListInfoByStatus(int Status)
    {
        Underwriting.UnderwritingStatusEnum estatus = (Underwriting.UnderwritingStatusEnum)Status;
        using (var ctx = new UnderwritingEntity())
        {
            var underwritings = from underwriting in ctx.Underwritings
                                where underwriting.Status == estatus
                                select new
                                {
                                    BBLE = underwriting.BBLE,
                                    UnderwritingStatus = underwriting.Status,
                                    UnderwritingCreateBy = underwriting.CreateBy,
                                    UnderwritingCreateDate = underwriting.CreateDate,
                                    UnderwritingUpdateDate = underwriting.UpdateDate
                                };
            return underwritings.ToArray();

        }
    }

    public static void ChangeStatus(string BBLE, Underwriting.UnderwritingStatusEnum status, string statusNote, string updateBy)
    {
        using (var ctx = new UnderwritingEntity())
        {
            var underwriting = ctx.Underwritings.FirstOrDefault((u) => u.BBLE.Trim() == BBLE.Trim());
            if (underwriting != null)
            {
                underwriting.Status = status;
                underwriting.StatusNote = statusNote;
                underwriting.UpdateBy = updateBy;
                underwriting.UpdateDate = DateTime.Now;
                ctx.SaveChanges(updateBy);
                return;
            }
            else
            {
                throw new Exception("Underwriting with BBLE " + BBLE + " cannot be found.");
            }
        }
    }
}
