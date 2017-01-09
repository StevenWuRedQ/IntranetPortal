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
                uw.UpdateBy = saveby;
                uw.UpdateDate = DateTime.Now;
                ctx.Entry(u).CurrentValues.SetValues(uw);
                EntityHelper<Underwriting>.ReferenceUpdate(ctx, u, uw);
            }
            else
            {
                uw.CreateBy = saveby;
                uw.CreateDate = DateTime.Now;
                ctx.Underwritings.Add(uw);
            }
            ctx.SaveChanges(saveby);
            return u;
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
                archived.PropertyInfo.Id = 0;
                archived.DealCosts = underwriting.DealCosts;
                archived.DealCosts.Id = 0;
                archived.RehabInfo = underwriting.RehabInfo;
                archived.RehabInfo.Id = 0;
                archived.RentalInfo = underwriting.RentalInfo;
                archived.RentalInfo.Id = 0;
                archived.LienInfo = underwriting.LienInfo;
                archived.LienInfo.Id = 0;
                archived.LienCosts = underwriting.LienCosts;
                archived.LienCosts.Id = 0;

                ctx.UnderwritingArchived.Add(archived);
                ctx.SaveChanges(saveBy);
            }
            return archived;
        }
    }

    public static Underwriting Create(string BBLE, string createby)
    {
        using (UnderwritingEntity ctx = new UnderwritingEntity())
        {
            dynamic u = new Underwriting();
            u.BBLE = BBLE;
            u.CreateBy = createby;
            u.CreateDate = DateTime.Now;

            u.PropertyInfo = new UnderwritingPropertyInfo();
            u.DealCosts = new UnderwritingDealCosts();
            u.RehabInfo = new UnderwritingRehabInfo();
            u.RentalInfo = new UnderwritingRentalInfo();
            u.LienInfo = new UnderwritingLienInfo();
            u.LienCosts = new UnderwritingLienCosts();


            u.Status = Underwriting.UnderwritingStatusEnum.NewCreated;

            ctx.Underwritings.Add(u);
            ctx.SaveChanges(createby);
            return u;
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
}
