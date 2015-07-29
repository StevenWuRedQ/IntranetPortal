Public Class PropertyMap
    Inherits System.Web.UI.Page

    Public Property DisplayView As ViewType = ViewType.PropertyMap


    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not String.IsNullOrEmpty(Request.QueryString("v")) Then
            DisplayView = CInt(Request.QueryString("v"))

            Select Case DisplayView
                Case ViewType.PropertyMap
                    contentSplitter.ClientSideEvents.Init = "function(s,e){popupControlMapTabClick(0);}"
                Case ViewType.Acris
                    contentSplitter.GetPaneByName("mapPane").ContentUrl = "https://a836-acris.nyc.gov/DS/DocumentSearch/BBL"
                Case ViewType.DOB
                    Dim ld = LeadsInfo.GetInstance(Request.QueryString("bble"))
                    If ld IsNot Nothing Then
                        contentSplitter.GetPaneByName("topTab").Visible = False
                        contentSplitter.GetPaneByName("mapPane").ContentUrl = "http://a810-bisweb.nyc.gov/bisweb/PropertyProfileOverviewServlet?boro=" + ld.Borough + "&block=" + ld.Block + "&lot=" + ld.Lot
                    End If
                Case ViewType.eCourts
                    contentSplitter.GetPaneByName("topTab").Visible = False
                    contentSplitter.GetPaneByName("mapPane").ContentUrl = "https://iapps.courts.state.ny.us/webcivil/ecourtsMain"
            End Select
        End If
    End Sub

    Public Enum ViewType
        PropertyMap
        Acris
        DOB
        eCourts
    End Enum
End Class