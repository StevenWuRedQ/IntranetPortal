Imports IntranetPortal.ShortSale
Imports Newtonsoft.Json
Imports System.Web.Script.Serialization

Public Class ShortSaleOverVew
    Inherits System.Web.UI.UserControl

    Public Property shortSaleCaseData As New ShortSaleCase
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

    End Sub

    Protected Sub overviewCallbackPanel_Callback(sender As Object, e As DevExpress.Web.ASPxClasses.CallbackEventArgsBase)

    End Sub

    Public Sub BindData(shortSale As ShortSaleCase)
        hfCaseId.Value = shortSale.CaseId

        shortSaleCaseData = shortSale
        ShortSalePropertyTab.propertyInfo = shortSaleCaseData.PropertyInfo
        ShortSalePropertyTab.BindData()
        ShortSaleHomewonerTab.homeOwners = shortSaleCaseData.PropertyInfo.Owners
        ShortSaleMortgageTab.mortgagesData = shortSaleCaseData.Mortgages
        ShortSaleEvictionTab.evictionData = shortSaleCaseData
        ShortSaleSummaryTab.summaryCase = shortSaleCaseData
    End Sub

    Protected Sub SaveClicklCallback_Callback(source As Object, e As DevExpress.Web.ASPxCallback.CallbackEventArgs)
        Dim res = JsonConvert.DeserializeObject(Of ShortSaleCase)(e.Parameter)

        res.SaveChanges()
    End Sub

    Public Function getShortSaleJson(data As ShortSaleCase) As String
        Dim serializer As New JavaScriptSerializer
        Dim json = serializer.Serialize(data)
        Return json
    End Function

    Protected Sub getShortSaleInstance_Callback(source As Object, e As DevExpress.Web.ASPxCallback.CallbackEventArgs)
        Dim ID As String = e.Parameter
        e.Result = getShortSaleJson(ShortSaleCase.GetCase(Convert.ToInt32(ID)))
    End Sub

    Protected Sub leadsCommentsCallbackPanel_Callback(sender As Object, e As DevExpress.Web.ASPxClasses.CallbackEventArgsBase)
        If shortSaleCaseData.CaseId = 0 AndAlso hfCaseId.Value IsNot Nothing Then
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
End Class