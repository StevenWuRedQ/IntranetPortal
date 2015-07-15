Imports PublicSiteData

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

    <HttpPost>
    Function List(category As String, searchCriteria As String) As ActionResult
        Dim criteria As New PublicSiteData.SearchCriteria
        criteria.Type = category
        criteria.Keyword = searchCriteria
        criteria.Result = PublicSiteData.ListProperty.SearchList(criteria)
        Return View(criteria)
    End Function

    Function Search(criteria As SearchCriteria) As ActionResult
        If criteria Is Nothing Then
            criteria = New PublicSiteData.SearchCriteria
        End If
        criteria.Result = PublicSiteData.ListProperty.SearchList(criteria)
        Return View("List", criteria)
    End Function

    '<HttpPost>
    'Function List(criteria As SearchCriteria) As ActionResult
    '    criteria.Result = ListProperty.SearchList(criteria)
    '    Return View(criteria)
    'End Function

    Function AgentInfo(id As Integer) As ActionResult
        Dim agent = PortalAgent.GetAgent(id)
        Return View("AgentDetail", agent)
    End Function

    Function Agents() As ActionResult
        Return View()
    End Function

    Function About() As ActionResult
        Return View()
    End Function

    Function WeBuyHouse() As ActionResult
        Return View()
    End Function

    Function Contact() As ActionResult
        ViewData("Message") = "Your contact page."

        Return View()
    End Function
End Class
