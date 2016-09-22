Imports System.Net
Imports System.Web.Http
Imports Newtonsoft.Json.Linq
Imports IntranetPortal.Data

Namespace Controllers

    ''' <summary>
    ''' The web controller for PropertyOffer
    ''' </summary>
    Public Class PropertyOfferController
        Inherits ApiController

        ''' <summary>
        ''' Generate the document package
        ''' </summary>
        ''' <param name="bble">The property bble</param>
        ''' <param name="data">The form data</param>
        ''' <returns>The generated file link</returns>
        <Route("api/PropertyOffer/GeneratePackage/{bble}")>
        Public Function PostGeneratePackage(bble As String, <FromBody> data As JObject) As IHttpActionResult
            Try
                Dim path = HttpContext.Current.Server.MapPath("~/App_Data/OfferDoc")
                Dim destPath = HttpContext.Current.Server.MapPath("/TempDataFile/OfferDoc/")
                Dim fileName = PropertyOfferManage.GeneratePackage(bble, data, path, destPath)
                Return Ok("/TempDataFile/OfferDoc/" & fileName)
            Catch ex As Exception
                Return BadRequest(ex.Message)
            End Try
        End Function

        ''' <summary>
        ''' Load user property offers
        ''' </summary>
        ''' <returns>Property Offer list</returns>
        <Route("api/PropertyOffer/")>
        Public Function GetPropertyOffers() As IHttpActionResult
            Dim name = HttpContext.Current.User.Identity.Name
            Dim mgrView = HttpContext.Current.Request.QueryString("mgrview")
            Dim summary = HttpContext.Current.Request.QueryString("summary")
            Dim isSummary = False

            If Boolean.TryParse(summary, isSummary) Then

            End If


            Dim result() As PropertyOffer = {}
            If Not String.IsNullOrEmpty(mgrView) Then
                Dim view As PropertyOfferManage.ManagerView = 0
                If Integer.TryParse(mgrView, view) Then
                    result = (PropertyOfferManage.GetOffersByManagerView(name, view, isSummary))
                End If
            Else
                If Employee.IsAdmin(name) OrElse User.IsInRole("NewOffer-Viewer") Then
                    name = "*"
                End If

                result = PropertyOffer.GetOffers(name)
            End If

            If result.Count > 0 AndAlso Not String.IsNullOrEmpty(summary) Then
                If isSummary Then
                    Dim data = New With {
                            .data = result.OrderByDescending(Function(d) d.UpdateDate).Take(10).ToArray,
                            .count = result.Count
                        }
                    Return Ok(data)
                End If
            End If

            Return Ok(result)
        End Function

        ''' <summary>
        ''' Load user property offers
        ''' </summary>
        ''' <returns>Property Offer list</returns>
        <Route("api/PropertyOffer/IsCompleted/{bble}")>
        Public Function GetPropertyIsCompleted(bble As String) As IHttpActionResult

            Dim offer = PropertyOffer.GetOffer(bble)
            If offer IsNot Nothing AndAlso offer.Status = PropertyOffer.OfferStatus.Completed Then
                Return Ok(True)
            End If

            Return Ok(False)
        End Function


        <HttpPost>
        <Route("api/PropertyOffer/PostPerformance")>
        Public Function PostPerformance(<FromBody> data As Object) As IHttpActionResult
            Dim x = Request.Content
            If data IsNot Nothing Then
                Dim startDate = New DateTime().Parse(data("StartDate").ToString)
                Dim endDate = New DateTime().Parse(data("EndDate").ToString)
                Dim empName = data("EmpName").ToString
                Dim teamName = data("TeamName").ToString

                Dim result = PropertyOfferManage.getPerformance(startDate, endDate, empName, teamName)
                Return Ok(result)
            End If
            Return Ok()
        End Function

    End Class
End Namespace