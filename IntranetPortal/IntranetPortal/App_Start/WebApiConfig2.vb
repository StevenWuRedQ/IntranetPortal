Imports System
Imports System.Collections.Generic
Imports System.Linq
Imports System.Web.Http
Imports System.Web.Http.OData.Builder
Imports System.Web.Http.OData.Extensions
Imports System.Net.Http.Formatting

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
        '''''''''Test url like api/xxx.json and api/xxx.xml
        'config.Routes.MapHttpRoute(
        '    name:="Api UriPathExtension",
        '    routeTemplate:="api/{controller}.{extension}/{id}",
        '    defaults:=New With {.id = RouteParameter.Optional, .extension = RouteParameter.Optional}
        ')
        'config.Routes.MapHttpRoute(
        '    name:="Api UriPathExtension ID",
        '    routeTemplate:="api/{controller}/{id}.{extension}",
        '    defaults:=New With {.id = RouteParameter.Optional, .extension = RouteParameter.Optional}
        ')

        'config.Formatters.XmlFormatter.AddUriPathExtensionMapping("xml", "application/xml")
        'config.Formatters.JsonFormatter.AddUriPathExtensionMapping("json", "application/json; charset=utf-8")
        ''''''''''''''''''end test
        Dim builder As New ODataConventionModelBuilder
        builder.EntitySet(Of NYC_Scan_TaxLiens_Per_Year)("TaxLiensOData")
        builder.EntitySet(Of IntranetPortal.Data.ShortSaleLeadsInfo)("ShortSaleLeadsInfoes")
        config.Routes.MapODataServiceRoute("odata", "odata", builder.GetEdmModel())
        'GlobalConfiguration.Configuration.Filters.Add(New WebApiException)

        'config.Filters.Add(New WebApiException)
    End Sub

End Class