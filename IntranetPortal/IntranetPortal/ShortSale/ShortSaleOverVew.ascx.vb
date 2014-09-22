Imports IntranetPortal.ShortSale
Imports Newtonsoft.Json

Public Class ShortSaleOverVew
    Inherits System.Web.UI.UserControl

    Public Property shortSaleCaseData As New ShortSaleCase
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

    End Sub


    Protected Sub overviewCallbackPanel_Callback(sender As Object, e As DevExpress.Web.ASPxClasses.CallbackEventArgsBase)

    End Sub

    Public Sub BindData(shortSale As ShortSaleCase)
        shortSaleCaseData = shortSale
        ShortSalePropertyTab.propertyInfo = shortSaleCaseData.PropertyInfo
        ShortSaleHomewonerTab.homeOwners = shortSaleCaseData.PropertyInfo.Owners
        ShortSaleMortgageTab.mortgagesData = shortSaleCaseData.Mortgages
        ShortSaleEvictionTab.evictionData = shortSaleCaseData
    End Sub

    Protected Sub SaveClicklCallback_Callback(source As Object, e As DevExpress.Web.ASPxCallback.CallbackEventArgs)
        Dim res = JsonConvert.DeserializeObject(Of ShortSaleCase)(e.Parameter)
       
        res.SaveChanges()
    End Sub
   
End Class