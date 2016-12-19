Imports System.Web.Http
Imports System.Web.Http.OData.Builder
Imports System.Web.Http.OData.Extensions

Public Class WebApiConfig2
    Public Shared Sub Register(ByVal config As HttpConfiguration)
        ' Web API configuration and services

        ' Web API routes
        config.MapHttpAttributeRoutes()

        config.Routes.MapHttpRoute(
            name:="DefaultApi",
            routeTemplate:="api/{controller}/{id}",
            defaults:=New With {.id = RouteParameter.Optional}
        )
        '''''''''Test url like api/xxx.json and api/xxx.xml''''
        'Dim key = UriPathExtensionMapping.UriPathExtensionKey
        'config.Formatters.XmlFormatter.AddUriPathExtensionMapping("xml", "application/xml")
        'config.Formatters.JsonFormatter.AddUriPathExtensionMapping("json", "application/json")
        'config.Routes.MapHttpRoute(
        '    name:="Api UriPathExtension",
        '    routeTemplate:="api/{controller}.{ext}/{id}",
        '    defaults:=New With {.id = RouteParameter.Optional, .ext = RouteParameter.Optional}
        ')
        'config.Routes.MapHttpRoute(
        '    name:="Api UriPathExtension ID",
        '    routeTemplate:="api/{controller}/{id}.{ext}",
        '    defaults:=New With {.id = RouteParameter.Optional, .ext = RouteParameter.Optional}
        ')


        ''''''''''''''''''end test''''''''''''''''''''''''''
        Dim builder As New ODataConventionModelBuilder
        builder.EntitySet(Of NYC_Scan_TaxLiens_Per_Year)("TaxLiensOData")
        builder.EntitySet(Of IntranetPortal.Data.ShortSaleLeadsInfo)("ShortSaleLeadsInfoes")
        config.Routes.MapODataServiceRoute("odata", "odata", builder.GetEdmModel())
        'GlobalConfiguration.Configuration.Filters.Add(New WebApiException)

        config.Filters.Add(New WebApiException)

        Dim formatters = GlobalConfiguration.Configuration.Formatters
        formatters.Remove(formatters.XmlFormatter)
    End Sub

End Class