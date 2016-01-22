Imports System
Imports System.Collections.Generic
Imports System.Linq
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

        Dim builder As New ODataConventionModelBuilder
        builder.EntitySet(Of NYC_Scan_TaxLiens_Per_Year)("TaxLiensOData")
        builder.EntitySet(Of IntranetPortal.Data.ShortSaleLeadsInfo)("ShortSaleLeadsInfoes")
        config.Routes.MapODataServiceRoute("odata", "odata", builder.GetEdmModel())
        GlobalConfiguration.Configuration.Filters.Add(New WebApiException)

    End Sub

End Class