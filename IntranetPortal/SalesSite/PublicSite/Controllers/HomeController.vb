Public Class HomeController
    Inherits System.Web.Mvc.Controller

    Function Index() As ActionResult
        ViewData("Agents") = PublicSiteData.PortalAgent.AgentList
        ViewData("RecentListing") = PublicSiteData.ListProperty.GetRecentListing
        Return View()
    End Function

    Function Detail(id As String) As ActionResult
        Dim bble = id
        Return View(PublicSiteData.ListProperty.GetProperty(bble))
    End Function

    Function About() As ActionResult
        ViewData("Message") = "Your application description page."

        Return View()
    End Function

    Function Contact() As ActionResult
        ViewData("Message") = "Your contact page."

        Return View()
    End Function
End Class
