Imports IntranetPortal.Core
Imports Newtonsoft.Json.Linq
''' <summary>
''' Represent Auction property object and related operations
''' </summary>
Public Class AuctionProperty

    Public Shared Function GetAuctionProperty(id As Integer) As AuctionPropertyView
        Using ctx As New PortalEntities
            Return ctx.AuctionPropertyViews.Find(id)
        End Using
    End Function

    Public Shared Function Import(fileName As String, importBy As String) As Integer

        Dim auctions = LoadAuctionProperties(fileName)
        Using ctx As New PortalEntities
            For Each prop In auctions
                prop.CreateDate = DateTime.Now
                prop.CreateBy = importBy
                ctx.AuctionProperties.Add(prop)
            Next

            ctx.SaveChanges()
        End Using

        InitData(auctions, importBy)

        Return auctions.Count
    End Function

    Private Shared Sub InitData(props As AuctionProperty(), updateBy As String)
        DataLoopRule.AddRules(props.Select(Function(p) p.BBLE).ToArray, DataLoopRule.DataLoopType.GeneDataAndMortgage, updateBy)
    End Sub

    Public Shared Function LoadAuctionProperties(fileName As String) As AuctionProperty()
        Dim ds = ExcelHelper.LoadDataFromExcel(fileName)

        Dim result As New List(Of AuctionProperty)
        For Each row In ds.Tables(0).Rows
            result.Add(BuildAuctionProperty(row))
        Next
        Return result.ToArray
    End Function

    Public Shared Function LoadNotifyProperties(startDate As DateTime, endDate As DateTime) As AuctionProperty()

        Using ctx As New PortalEntities

            Dim props = ctx.AuctionProperties.Where(Function(a) a.AuctionDate > startDate AndAlso a.AuctionDate < endDate).ToArray
            Return props
        End Using
    End Function

    Private Shared Function BuildAuctionProperty(row As DataRow) As AuctionProperty
        Dim prop As New AuctionProperty
        prop.Address = DataRowString("Address", row)
        prop.Zipcode = DataRowString("Zip Code", row)
        prop.Neighborhood = DataRowString("Neighborhood", row)
        prop.BuildingClass = DataRowString("Building Class", row)
        prop.BBL = DataRowString("BBL", row)
        prop.BBLE = BuildBBLE(prop.BBL)
        prop.AuctionDate = BuildAuctionDate(DataRowString("Auction Date", row), DataRowString("Auction Time", row))
        prop.DateEntered = DataRowDate("Date Entered", row)
        prop.Lien = DataRowDecimal("Lien", row)
        prop.Judgment = DataRowDate("Judgment", row)
        prop.Plaintiff = DataRowString("Plaintiff", row)
        prop.Defendant = DataRowString("Defendant", row)
        prop.IndexNo = DataRowString("Index No#", row)
        prop.Referee = DataRowString("Referee", row)
        prop.AuctionLocation = DataRowString("Auction Location", row)
        prop.PlaintiffAttorney = DataRowString("Plaintiff's Attorney", row)
        prop.AttorneyPhone = DataRowString("Attorney's Phone", row)
        prop.ForeclosureType = DataRowString("Foreclosure Type", row)

        prop.AgentAssigned = DataRowString("Agent Assigned", row)
        'prop.Grade = DataRowString("Grade", row)
        'prop.TaxWaterCombo = DataRowDecimal("Taxes/Water Combo", row)
        'prop.DOBViolation = DataRowDecimal("DOB Violations", row)
        'prop.PreviousAuctionDate = DataRowDate("Previous Auction Date", row)
        'prop.DeedRecorded = DataRowDate("Memo/Deed Recorded", row)
        'prop.MaxAuctionBid = DataRowDecimal("Max. Auction Bid", row)
        'prop.RenovatedValue = DataRowDecimal("Renovated Value", row)
        'prop.Points = DataRowString("Point", row)
        'prop.LeadType = DataRowString("Lead Type", row)

        Return prop
    End Function

    Private Shared Function DataRowString(colName As String, row As DataRow) As String
        If Not row.Table.Columns.Contains(colName) Then
            Return Nothing
        End If

        If row.IsNull(colName) Then
            Return Nothing
        End If

        Dim result = row(colName).ToString
        If String.IsNullOrEmpty(result) Then
            Return Nothing
        End If

        Return result
    End Function

    Private Shared Function DataRowDecimal(colName As String, row As DataRow) As Decimal?

        Dim amount = DataRowString(colName, row)
        If String.IsNullOrEmpty(amount) Then
            Return Nothing
        End If

        amount = amount.Replace("$", "").Replace(",", "")

        Dim result = 0
        If Decimal.TryParse(amount, result) Then
            Return result
        End If
        Return Nothing
    End Function

    Private Shared Function DataRowDate(colName As String, row As DataRow) As DateTime?
        Dim result As DateTime
        If DateTime.TryParse(DataRowString(colName, row), result) Then
            Return result
        Else
            Return Nothing
        End If
    End Function

    Private Shared Function BuildAuctionDate(auctionDate As String, auctionTime As String) As DateTime?
        If String.IsNullOrEmpty(auctionDate) Then
            Return Nothing
        End If

        Dim result As DateTime
        If DateTime.TryParse(auctionDate & " " & auctionTime, result) Then
            Return result
        Else
            Return Nothing
        End If
    End Function

    Private Shared Function BuildBBLE(bbl As String) As String
        If String.IsNullOrEmpty(bbl) Then
            Return Nothing
        End If

        Dim data = bbl.Split("-")
        If data.Length > 2 Then
            Return data(0) & data(1) & data(2)
        End If
        Return bbl
    End Function

End Class

Partial Public Class AuctionPropertyView
    Public ReadOnly Property TaxWaterCombo As Decimal?
        Get
            Dim data = {TaxesAmt, WaterAmt}

            If data.Any(Function(d) d.HasValue) Then
                Return data.Where(Function(d) d.HasValue).Sum()
            Else
                Return Nothing
            End If
        End Get
    End Property

End Class
