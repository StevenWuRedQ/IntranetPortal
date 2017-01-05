using System;
using System.Collections.Generic;
using System.Linq;
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
        using (UnderwritingEntity ctx = new UnderwritingEntity())
        {
            dynamic u = ctx.Underwritings.SingleOrDefault(t => t.BBLE == uw.BBLE);
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

    public static bool Archive(string bble, string saveBy, string note)
    {
        using (UnderwritingEntity ctx = new UnderwritingEntity())
        {
            dynamic uw = GetUnderwritingByBBLE(bble);
            if (uw != null)
            {
                dynamic uwa = new UnderwritingArchived();

                uwa.BBLE = uw.BBLE;
                uwa.ArchivedBy = saveBy;
                uwa.ArchivedDate = DateTime.Now;
                uwa.ArchivedNote = note;

                uwa.PropertyInfo = uw.PropertyInfo;
                uwa.PropertyInfo.Id = null;
                uwa.DealCosts = uw.DealCosts;
                uwa.DealCosts.Id = null;
                uwa.RehabInfo = uw.RehabInfo;
                uwa.RehabInfo.Id = null;
                uwa.RentalInfo = uw.RentalInfo;
                uwa.RentalInfo.Id = null;
                uwa.LienInfo = uw.LienInfo;
                uwa.LienInfo.Id = null;
                uwa.LienCosts = uw.LienCosts;
                uwa.LienCosts.Id = null;

                ctx.UnderwritingArchived.Add(uwa);
                ctx.SaveChanges(saveBy);
                return true;
            }
            return false;
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
            ctx.SaveChanges();
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

    
}
