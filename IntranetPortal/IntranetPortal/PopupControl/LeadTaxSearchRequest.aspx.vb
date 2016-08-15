Public Class LeadTaxSearchRequest
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        If (Not IsPostBack) Then
            'Me.DocSearchOldVersion.SearchRecodingPopupCtrl1.BBLE = Request.QueryString("BBLE")

            If (Request.QueryString("BBLE") IsNot Nothing) Then
                ASPxSplitter1.GetPaneByName("listPanel").Visible = False
                ASPxSplitter1.GetPaneByName("dataPane").Visible = False
            End If

            ' '''''''''''''''''''''''''''''''''''''''''''''''
            ' push test
            ' disable server side control
            ' date 8/12/2016
            ' 
            ' If Request.QueryString("v") IsNot Nothing Then
            '    Me.DocSearchOldVersion.Visible = False
            '    Me.DocSearchNewVersion.Visible = True
            ' End If
            ' ''''''''''''''''''''''''''''''''''''''''''''''''
        End If
    End Sub

End Class