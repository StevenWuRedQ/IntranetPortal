Imports IntranetPortal.ShortSale
Imports IntranetPortal

Public Class Form1

    Private Sub Button1_Click(sender As Object, e As EventArgs) Handles Button1.Click
        ImportShortSale(txtBBLE.Text)
    End Sub

    Public Sub ImportShortSale(bble As String)
        Dim li = LeadsInfo.GetInstance(bble)

        If li IsNot Nothing Then
            Dim propBase = SaveProp(bble)
            Dim ssCase As New ShortSaleCase(propBase)
            ssCase.BBLE = bble
            ssCase.CaseName = li.LeadsName
            ssCase.CreateBy = "TestForm"
            ssCase.CreateDate = DateTime.Now
            ssCase.Save()
        End If
    End Sub

    Public Function SaveProp(bble As String) As IntranetPortal.ShortSale.PropertyBaseInfo
        Dim li = LeadsInfo.GetInstance(bble)
        Dim propBase = New IntranetPortal.ShortSale.PropertyBaseInfo
        propBase.BBLE = li.BBLE
        propBase.Block = li.Block
        propBase.Lot = li.Lot
        propBase.Number = li.Number
        propBase.StreetName = li.StreetName
        propBase.City = li.NeighName
        propBase.Zipcode = li.ZipCode
        propBase.TaxClass = li.TaxClass
        propBase.NumOfStories = li.NumFloors
        propBase.CreateDate = DateTime.Now
        propBase.CreateBy = "Testing"
        propBase.Save()
        Return propBase
    End Function

    Private Sub Button2_Click(sender As Object, e As EventArgs) Handles Button2.Click
        SaveProp(txtBBLE.Text)
    End Sub

End Class
