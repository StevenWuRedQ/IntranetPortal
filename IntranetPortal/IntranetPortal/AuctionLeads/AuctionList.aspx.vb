Public Class AuctionList
    Inherits PortalPage

    Public Property ControlType As String
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        ControlType = Request.QueryString("ct")
        Dim controlDic = New Dictionary(Of String, UserControl)
        controlDic.Add("Auction Properties", Me.AuctionListCtrl)
        controlDic.Add("Vacant Properties", Me.VacantListCtrl)
        If (String.IsNullOrEmpty(ControlType)) Then
            AuctionListCtrl.Visible = True
        Else
            controlDic.Item(ControlType).Visible = True
        End If

    End Sub

End Class