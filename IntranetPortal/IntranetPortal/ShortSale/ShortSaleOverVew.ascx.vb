Imports IntranetPortal.Data
Imports Newtonsoft.Json
Imports System.Web.Script.Serialization

Public Class ShortSaleOverVew
    Inherits System.Web.UI.UserControl

    Public Property shortSaleCaseData As New ShortSaleCase
    Public ReadOnly Property isEviction As Boolean
        Get
            Dim ShhortSale = CType(Me.Page, NGShortSale)
            Return ShhortSale.isEviction
        End Get
    End Property

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

    End Sub

    Protected Sub overviewCallbackPanel_Callback(sender As Object, e As DevExpress.Web.CallbackEventArgsBase)

    End Sub

    Public Sub BindData(shortSale As ShortSaleCase)
        hfCaseId.Value = shortSale.CaseId
        hfBBLE.Value = shortSale.BBLE

        shortSaleCaseData = shortSale
        ShortSalePropertyTab.propertyInfo = shortSaleCaseData.PropertyInfo
        ShortSalePropertyTab.BindData(shortSale.CaseId)
        'ShortSaleHomewonerTab.homeOwners = shortSaleCaseData.PropertyInfo.Owners
        'ShortSaleMortgageTab.mortgagesData = shortSaleCaseData.Mortgages
        ShortSaleEvictionTab.evictionData = shortSaleCaseData
        ShortSaleSummaryTab.summaryCase = shortSaleCaseData

        gvPropertyValueInfo.DataSource = shortSale.ValueInfoes
        gvPropertyValueInfo.DataBind()
    End Sub

    Protected Sub SaveClicklCallback_Callback(source As Object, e As DevExpress.Web.CallbackEventArgs)
        Dim res = JsonConvert.DeserializeObject(Of ShortSaleCase)(e.Parameter)

        res.SaveChanges()

        e.Result = JsonConvert.SerializeObject(ShortSaleCase.GetCase(res.CaseId))
    End Sub

    Public Function getShortSaleJson(data As ShortSaleCase) As String
        Dim serializer As New JavaScriptSerializer
        Dim json = serializer.Serialize(data)
        Return json
    End Function

    Protected Sub getShortSaleInstance_Callback(source As Object, e As DevExpress.Web.CallbackEventArgs)
        Dim ID As String = e.Parameter
        e.Result = getShortSaleJson(ShortSaleCase.GetCase(Convert.ToInt32(ID)))
    End Sub

    Protected Sub leadsCommentsCallbackPanel_Callback(sender As Object, e As DevExpress.Web.CallbackEventArgsBase)
        If shortSaleCaseData.CaseId = 0 AndAlso Not String.IsNullOrEmpty(hfCaseId.Value) Then
            shortSaleCaseData = ShortSaleCase.GetCase(CInt(hfCaseId.Value))
        End If

        If e.Parameter.StartsWith("Add") Then
            Dim comm As New ShortSaleCaseComment
            comm.Comments = e.Parameter.Split("|")(1)
            comm.CreateBy = Page.User.Identity.Name
            comm.CreateDate = DateTime.Now
            comm.CaseId = shortSaleCaseData.CaseId
            comm.Save()
        End If

        If e.Parameter.StartsWith("Delete") Then
            Dim commentId = CInt(e.Parameter.Split("|")(1))
            ShortSaleCaseComment.DeleteComment(commentId)
        End If
    End Sub

    Protected Sub gvPropertyValueInfo_RowInserting(sender As Object, e As DevExpress.Web.Data.ASPxDataInsertingEventArgs)
        Dim info As New PropertyValueInfo
        info.BBLE = hfBBLE.Value
        info.Method = e.NewValues("Method")
        info.BankValue = e.NewValues("BankValue")
        info.DateOfValue = e.NewValues("DateOfValue")
        info.ExpiredOn = e.NewValues("ExpiredOn")
        info.MNSP = e.NewValues("MNSP")
        info.Save()

        e.Cancel = True
        gvPropertyValueInfo.CancelEdit()

        gvPropertyValueInfo.DataBind()
    End Sub

    Protected Sub gvPropertyValueInfo_RowUpdating(sender As Object, e As DevExpress.Web.Data.ASPxDataUpdatingEventArgs)
        Dim info = PropertyValueInfo.GetValueInfo(e.Keys(0))
        info.Method = e.NewValues("Method")
        info.BankValue = e.NewValues("BankValue")
        info.DateOfValue = e.NewValues("DateOfValue")
        info.ExpiredOn = e.NewValues("ExpiredOn")
        info.MNSP = e.NewValues("MNSP")
        info.Save()

        e.Cancel = True
        gvPropertyValueInfo.CancelEdit()

        gvPropertyValueInfo.DataBind()
    End Sub

    Protected Sub gvPropertyValueInfo_RowDeleting(sender As Object, e As DevExpress.Web.Data.ASPxDataDeletingEventArgs)
        PropertyValueInfo.DeleteValueInfo(e.Keys(0))

        e.Cancel = True
        gvPropertyValueInfo.DataBind()
    End Sub

    Protected Sub gvPropertyValueInfo_DataBinding(sender As Object, e As EventArgs)
        If gvPropertyValueInfo.DataSource Is Nothing Then
            gvPropertyValueInfo.DataSource = PropertyValueInfo.GetValueInfos(hfBBLE.Value)
        End If
    End Sub
End Class