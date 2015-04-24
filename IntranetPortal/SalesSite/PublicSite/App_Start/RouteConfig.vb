Imports System
Imports System.Collections.Generic
Imports System.Linq
Imports System.Web
Imports System.Web.Mvc
Imports System.Web.Routing

Public Module RouteConfig
    Public Sub RegisterRoutes(ByVal routes As RouteCollection)
        RouteTable.Routes.Add("ImageRoute", New Route("getImage/{imageId}", New RouteValueDictionary(New With {.imageId = 0}), New ImageHandler))
        RouteTable.Routes.Add("AgentImageRoute", New Route("getAgentImage/{agentId}", New ImageHandler))

        routes.IgnoreRoute("{resource}.axd/{*pathInfo}")
        routes.IgnoreRoute("{resource}.ashx/{*pathInfo}")

        routes.MapRoute(
            name:="Default",
            url:="{controller}/{action}/{id}",
            defaults:=New With {.controller = "Home", .action = "Index", .id = UrlParameter.Optional}
        )
    End Sub
End Module