Imports System.Net
Imports System.Web.Http

Namespace Controllers
    Public Class PortalReportController
        Inherits ApiController

        <Route("api/PortalReport/{startDate}/{endDate}")>
        Public Function GetLeadsImportReport(startDate As Date, endDate As Date) As IHttpActionResult
            If endDate < startDate Then
                Return BadRequest("The end date must greater than start date.")
            End If

            Dim result = PortalReport.LeadsImportReport(startDate, endDate)

            Return Ok(result)
        End Function

        <Route("api/PortalReport/")>
        Public Function GetLeadsImportingReport(teamName As String, startDate As DateTime) As IHttpActionResult
            Dim leadsData = PortalReport.TeamLeadsImportingReport(teamName, startDate, startDate.AddDays(7))
            Dim result = leadsData.Select(Function(ld) New With {.BBLE = ld.BBLE,
                       .LeadsName = ld.LeadsName,
                       .EmployeeName = ld.EmployeeName,
                       .LastUpdate = ld.LastUpdate,
                       .Callback = ld.CallbackDate,
                       .DeadReason = If(ld.DeadReason.HasValue, CType(ld.DeadReason, Lead.DeadReasonEnum).ToString, ""),
                       .Description = ld.Description
                                              }).ToArray

            Return Ok(result)
        End Function

        <Route("api/PortalReport/{TeamName}")>
        Public Function GetTeamImportReport(teamName As String) As IHttpActionResult

            Dim result = PortalReport.WeeklyTeamImportReport(teamName)
            Return Ok(result)
        End Function

    End Class
End Namespace