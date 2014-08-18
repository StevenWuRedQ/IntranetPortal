Public Class NavMenu
    Inherits System.Web.UI.UserControl

    Private XmlDataFile As String = "~/App_Data/PortalMenu.xml"
    Public Property PortalMenuItems As List(Of PortalNavItem)

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        LoadMenuFromXml()
    End Sub

    Public Sub InitialMenu()
        Dim item As New PortalNavItem
        item.Name = "Manager"
        item.Text = "Manager"
        item.NavigationUrl = "/summary.aspx"

        PortalMenuItems = New List(Of PortalNavItem)
        PortalMenuItems.Add(item)
    End Sub

    Public Sub WriteXML()
        Dim writer As New System.Xml.Serialization.XmlSerializer(GetType(List(Of PortalNavItem)))
        Dim file As New System.IO.StreamWriter(Server.MapPath(XmlDataFile))
        writer.Serialize(file, PortalMenuItems)
        file.Close()
    End Sub

    Public Sub LoadMenuFromXml()
        Dim reader As New System.Xml.Serialization.XmlSerializer(GetType(List(Of PortalNavItem)))
        Dim file As New System.IO.StreamReader(Server.MapPath(XmlDataFile))
        PortalMenuItems = CType(reader.Deserialize(file), List(Of PortalNavItem))
    End Sub
End Class