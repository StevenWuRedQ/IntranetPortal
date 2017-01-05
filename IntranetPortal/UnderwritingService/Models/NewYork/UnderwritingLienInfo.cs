using System;
using System.ComponentModel.DataAnnotations;

namespace RedQ.UnderwritingService.Models.NewYork
{
    public class UnderwritingLienInfo
    {
        [Key()]
        public int Id { get; set; }

        public double FirstMortgage { get; set; }
        public double SecondMortgage { get; set; }
        public bool COSRecorded { get; set; }
        public bool DeedRecorded { get; set; }
        public OtherLiensEnum OtherLiens { get; set; }
        public bool LisPendens { get; set; }
        public bool FHA { get; set; }
        public bool FannieMae { get; set; }
        public bool FreddieMac { get; set; }
        [MaxLength(50)]
        public string Servicer { get; set; }
        [MaxLength(50)]
        public string ForeclosureIndexNum { get; set; }
        [MaxLength(50)]
        public string ForeclosureStatus { get; set; }
        [MaxLength(256)]
        public string ForeclosureNote { get; set; }
        public DateTime AuctionDate { get; set; }
        public DateTime DefaultDate { get; set; }
        public double CurrentPayoff { get; set; }
        public DateTime PayoffDate { get; set; }
        public double CurrentSSValue { get; set; }

        public enum OtherLiensEnum
        {
            No = 1,
            CourtOrder = 2,
            MechanicsLien = 3,
            SpecificPerformance = 4,
            SundryAgreement = 5,
            UCC = 6
        }
        public enum ForeclosureStatusEnum
        {
            NotSure = 1,
            NoActionDismissed = 2,
            SummonsComplaint = 3,
            SettlementConference = 4,
            RJI = 5,
            OrderOfReference = 6,
            JudgmentOfForeclosureAndSale = 7
        }
    }
}