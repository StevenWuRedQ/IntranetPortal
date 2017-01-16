using System.ComponentModel.DataAnnotations;

namespace RedQ.UnderwritingService.Models.NewYork
{
    public class UnderwritingPropertyInfo
    {
        [Key()]
        public int Id { get; set; }

        public PropertyTypeEnum PropertyType { get; set; }

        [MaxLength(256)]
        public string PropertyAddress { get; set; }

        [MaxLength(50)]
        public string CurrentOwner { get; set; }

        [MaxLength(50)]
        public string TaxClass { get; set; }

        [MaxLength(50)]
        public string LotSize { get; set; }

        [MaxLength(50)]
        public string BuildingDimension { get; set; }

        [MaxLength(50)]
        public string Zoning { get; set; }

        public double  FARActual { get; set; }
        public double  FARMax { get; set; }
        public double  PropertyTaxYear { get; set; }
        public int? ActualNumOfUnits { get; set; }
        public OccupancyStatusEnum OccupancyStatus { get; set; }
        public bool SellerOccupied { get; set; }
        public int NumOfTenants { get; set; }

        public enum OccupancyStatusEnum
        {
            Unknown = 1,
            Vacant = 2,
            Seller = 3,
            SellerTenant = 4,
            Tenant = 5,
            MultipleTenant = 6
        }

        public enum PropertyTypeEnum
        {
            Residential = 1,
            NotResidential = 2
        }
    }
}