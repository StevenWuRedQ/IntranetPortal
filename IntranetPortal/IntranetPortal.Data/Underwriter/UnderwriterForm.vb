Imports System
Imports System.Data.Entity
Imports System.ComponentModel.DataAnnotations.Schema
Imports System.Linq
Imports System.ComponentModel.DataAnnotations

Partial Public Class UnderwriterEntity
    Inherits DbContext

    Public Overridable Property forms As DbSet(Of UnderwriterForm)



    Public Sub New()
        MyBase.New("name=UnderwriterEntity")
    End Sub


    Protected Overrides Sub OnModelCreating(ByVal modelBuilder As DbModelBuilder)
    End Sub
End Class

Public Class UnderwriterForm
    <Key>
    Public Property FormId As Integer


    Public Property Test As String


    Public Property CreateBy As String

    Public Property UpdateBy As String

    Public Property CreateDate As DateTime

    Public Property updateDate As DateTime
    Public Property NumofTenants As Integer

    Public Property NumofUnits As Integer

    Public Property FirstMortgage As Double
    Public Property SecondMortgage As Double
    Public Property ActualNumofUnits As Double
    Public Property AgentCommission As Double
    Public Property AuctionDate As DateTime
    Public Property AverageLowValue As Double
    Public Property BuildingDimension As Double
    Public Property COSRecorded As Boolean

    'Public Property COSTermination As 
    'Public Property CurrentPayoff
    'Public Property CurrentSSValue
    'Public Property CurrentlyRented
    'Public Property DOBCivilPenalty
    'Public Property DealROI
    'Public Property DealTime
    'Public Property DeedPurchase
    'Public Property DeedRecorded
    'Public Property DefaultDate
    'Public Property ECBDOBViolations
    'Public Property FHA
    'Public Property FannieMae
    'Public Property ForeclosureIndexNum
    'Public Property ForeclosureNote
    'Public Property ForeclosureStatus
    'Public Property FreddieMac
    'Public Property HOI
    'Public Property HPDCharges
    'Public Property HPDJudgements
    'Public Property IRSNYSTaxLiens
    'Public Property LotSize
    'Public Property MarketRentTotal
    'Public Property MoneySpent
    'Public Property Notes
    'Public Property OccupancyStatus
    'Public Property OtherLiens
    'Public Property PayoffDate
    'Public Property PersonalJudgements
    'Public Property PropertyAddress
    'Public Property PropertyTax
    'Public Property PropertyTaxes
    'Public Property RelocationLien
    'Public Property RelocationLienDate
    'Public Property RenovatedValue
    'Public Property RentalTime
    'Public Property RepairBid
    'Public Property RepairBidTotal
    'Public Property SalesCommission
    'Public Property SellerOccupied
    'Public Property Servicer
    'Public Property TaxClass
    'Public Property TaxLienCertificate
    'Public Property VacateOrder
    'Public Property WaterCharges
    'Public Property Zoning

End Class