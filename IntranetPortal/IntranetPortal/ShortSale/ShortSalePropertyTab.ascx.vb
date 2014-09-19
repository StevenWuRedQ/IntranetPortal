Imports Newtonsoft.Json
Public Class ShortSalePropertyTab
    Inherits System.Web.UI.UserControl
    Public Property propertyInfo As PropertyBaseInfo
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        initPropertyInfo()
        If (propertyInfo Is Nothing) Then
            propertyInfo = New PropertyBaseInfo
            propertyInfo.CO = True
            propertyInfo.BuildingType = "Condo"
            propertyInfo.Lot = 72
        End If


    End Sub
    Sub initPropertyInfo()
        Using Context As New Entities
            propertyInfo = Context.PropertyBaseInfoes.Where(Function(pi) pi.BBLE = "123").FirstOrDefault()
        End Using
    End Sub
    Class simplePropertyBaseInfo

        Public Property Number As String

        Public Property BuildingType As String

        Public Property CO As Nullable(Of Boolean)
        Public Property pdf_check_no21 As String
    End Class
    Protected Sub propertyTablCallback_Callback(source As Object, e As DevExpress.Web.ASPxCallback.CallbackEventArgs)
        Dim par = e.Parameter
        Dim res = JsonConvert.DeserializeObject(Of simplePropertyBaseInfo)(e.Parameter)
        par = ""
    End Sub

  

End Class