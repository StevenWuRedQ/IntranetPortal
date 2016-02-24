Public Class SummaryItemBase
    Inherits System.Web.UI.UserControl

    Public Property UserName As String

    Public Property ControlFileName As String

    Public Property Parameters As Dictionary(Of String, Object)

    Public Overridable Sub BindData()

    End Sub

End Class
