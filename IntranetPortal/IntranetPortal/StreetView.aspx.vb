Public Class StreetView
    Inherits System.Web.UI.Page

    Public Property Address As String
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not Page.IsPostBack Then
            Dim bble = Request.QueryString("bble")

            If Not String.IsNullOrEmpty(bble) Then
                Dim li = IntranetPortal.LeadsInfo.GetInstance(bble)
                If li IsNot Nothing Then
                    Address = li.PropertyAddress

                    If Not Page.ClientScript.IsStartupScriptRegistered("ShowAddress") Then
                        Dim cstext1 As String = "<script type=""text/javascript"">" & _
                                        String.Format("showAddress('{0}');", Address) & "</script>"
                        Page.ClientScript.RegisterStartupScript(Me.GetType, "ShowAddress", cstext1)
                    End If
                End If
            End If
        End If
    End Sub
End Class