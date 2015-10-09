Imports System.Net
Imports System.Web.Http
Imports System.Web.Http.Description
Imports IntranetPortal.Core

Namespace Controllers
    Public Class WorkingLogController
        Inherits ApiController

        <Route("api/WorkingLogs/{category}/{bble}")>
        Function GetComplaints(ByVal bble As String, category As String) As IHttpActionResult
            Dim logs = WorkingLog.GetLogs(bble, category)
            Dim total = logs.Aggregate(New TimeSpan(0), Function(l As TimeSpan, v As WorkingLog) l.Add(v.Duration))
            Dim result = New With {
                    .Total = String.Format("{0}:{1}:{2}", CInt(total.TotalHours), total.Minutes, total.Seconds),
                    .LogData = logs
                }

            Return Ok(result)
        End Function


    End Class
End Namespace