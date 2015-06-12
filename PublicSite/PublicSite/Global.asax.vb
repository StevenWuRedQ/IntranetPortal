Imports System.Web.Optimization

Public Class MvcApplication
    Inherits System.Web.HttpApplication

    Protected Sub Application_Start()
        AreaRegistration.RegisterAllAreas()
        FilterConfig.RegisterGlobalFilters(GlobalFilters.Filters)

        RouteTable.Routes.Add("AgentImageRoute", New Route("getAgentImage/{agentId}", New ImageHandler))
        RouteTable.Routes.Add("ImageRoute", New Route("getImage/{imageId}", New RouteValueDictionary(New With {.imageId = 0}), New ImageHandler))

        RouteConfig.RegisterRoutes(RouteTable.Routes)
        BundleConfig.RegisterBundles(BundleTable.Bundles)
    End Sub
End Class
